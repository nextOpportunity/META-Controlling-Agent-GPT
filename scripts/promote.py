#!/usr/bin/env python3
import argparse, json, os, sys

PHASE_THRESHOLDS = {
    "alpha": {"pass_rate": 0.90, "guardrail_violation_rate": 0.003, "decision_latency_p95_ms": 700, "sev1_days": 7},
    "beta":  {"pass_rate": 0.95, "guardrail_violation_rate": 0.002, "decision_latency_p95_ms": 500, "sev1_days": 14},
    "prod":  {"pass_rate": 0.97, "guardrail_violation_rate": 0.001, "decision_latency_p95_ms": 400, "sev1_days": 21},
}

def load_json(path, default=None):
    if not path or not os.path.exists(path):
        return default
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def main():
    ap = argparse.ArgumentParser(description="MCAG Promote Checker")
    ap.add_argument("--phase", required=True, choices=["alpha","beta","prod"], help="Zielphase")
    ap.add_argument("--report", required=True, help="Pfad zum Eval-Report (JSON)")
    ap.add_argument("--slos", default="mcag_starter/slos/slos.yaml", help="SLO-Definition (optional)")
    ap.add_argument("--incidents", default=None, help="Incident-Snapshot JSON (z. B. {'last_7d_sev1':0})")
    ap.add_argument("--latency_p95_ms", type=float, default=None, help="Gemessene Decision-Latency p95 (ms)")
    ap.add_argument("--guardrail_violation_rate", type=float, default=None, help="GVR (0..1)")
    args = ap.parse_args()

    thresholds = PHASE_THRESHOLDS[args.phase]

    # 1) Pass-Rate
    r = load_json(args.report, {}) or {}
    s = r.get("summary", {})
    total = max(1, int(s.get("total", 0)))
    passed = int(s.get("passed", 0))
    pass_rate = passed / total

    # 2) Incidents
    inc = load_json(args.incidents, {}) if args.incidents else {}
    sev_key = f"last_{thresholds['sev1_days']}d_sev1"
    sev_val = int(inc.get(sev_key, 0)) if isinstance(inc.get(sev_key, 0), (int,float)) else 0

    # 3) Optionale Metriken
    lat_p95 = args.latency_p95_ms
    gvr = args.guardrail_violation_rate

    reasons, ok = [], True
    if pass_rate < thresholds["pass_rate"]:
        ok, reasons = False, reasons + [f"Pass-Rate {pass_rate:.2%} < Ziel {thresholds['pass_rate']:.0%}"]
    if sev_val != 0:
        ok, reasons = False, reasons + [f"SEV1-Incidents in letzten {thresholds['sev1_days']} Tagen: {sev_val} (muss 0 sein)"]
    if lat_p95 is not None and lat_p95 > thresholds["decision_latency_p95_ms"]:
        ok, reasons = False, reasons + [f"Decision-Latency p95 {lat_p95:.0f} ms > Ziel {thresholds['decision_latency_p95_ms']} ms"]
    if gvr is not None and gvr > thresholds["guardrail_violation_rate"]:
        ok, reasons = False, reasons + [f"Guardrail-Violation-Rate {gvr:.3%} > Ziel {thresholds['guardrail_violation_rate']:.3%}"]

    status = "PASS" if ok else "FAIL"
    print(f"{args.phase.upper()} {status}")
    print(f"- pass_rate: {pass_rate:.2%} (Report: {os.path.basename(args.report)})")
    print(f"- incidents({sev_key}): {sev_val}")
    print(f"- decision_latency_p95_ms: {(f'{lat_p95:.0f}' if lat_p95 is not None else '(nicht angegeben)')}")
    print(f"- guardrail_violation_rate: {(f'{gvr:.3%}' if gvr is not None else '(nicht angegeben)')}")
    if reasons:
        print("Begründungen:")
        for r_ in reasons:
            print(f"  • {r_}")
    sys.exit(0 if ok else 2)

if __name__ == "__main__":
    main()
