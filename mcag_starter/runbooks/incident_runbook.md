# Incident-Runbook (MCAG)

## 1. Erkennen
- Alerts: guardrail-breach, drift-detected, latency-spike
- Quellen: OTEL-Traces, Logs, Eval-Dashboards

## 2. Eindämmen (innerhalb 15 Min)
- **Kill-Switch**: Traffic → Beta/Shadow
- Prompt/Policy-Rollback: letzte stabile Version
- Rate-Limits anpassen

## 3. Diagnostik
- `incident_id` anlegen, Hypothesenliste führen
- Diff von Prompt/Policies/Model-Routing prüfen
- Externe Abhängigkeiten (APIs) & Quoten checken

## 4. Beheben
- Fix minimalinvasiv, Canary 5%
- Metriken beobachten (10–30 Min)
- Stufenweise Ramp-up auf 100%

## 5. Nachbereitung (24–48 h)
- RCA (5×Warum), Korrekturmaßnahmen, Owner, ETA
- Wissensdatenbank aktualisieren
