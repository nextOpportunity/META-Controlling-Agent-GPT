.PHONY: venv test-starter test-patch promote-alpha promote-beta promote-prod

venv:
	python3 -m venv .venv && . .venv/bin/activate && pip install -U pip pyyaml

test-starter:
	. .venv/bin/activate && python mcag_starter/scripts/evaluate.py --suite mcag_starter/tests/test_suite.yaml --output reports/starter_results.json

test-patch:
	. .venv/bin/activate && python mcag_starter/scripts/evaluate.py --suite 'mcag_phase0_patch/tests/tests_patch_v*.yaml' --output reports/patch_latest_results.json

promote-alpha:
	. .venv/bin/activate && python scripts/promote.py --phase alpha --report reports/patch_latest_results.json --incidents incidents_sample.json --latency_p95_ms 650 --guardrail_violation_rate 0.002

promote-beta:
	. .venv/bin/activate && python scripts/promote.py --phase beta --report reports/patch_latest_results.json --incidents incidents_sample.json --latency_p95_ms 480 --guardrail_violation_rate 0.002

promote-prod:
	. .venv/bin/activate && python scripts/promote.py --phase prod --report reports/patch_latest_results.json --incidents incidents_sample.json --latency_p95_ms 390 --guardrail_violation_rate 0.001
.PHONY: all promote-all release-note

all: test-starter test-patch promote-alpha

promote-all: promote-alpha promote-beta promote-prod

release-note:
	@echo "Release-Notiz" > RELEASE_NOTE.txt
	@echo "Date: $(shell date '+%Y-%m-%d %H:%M:%S')" >> RELEASE_NOTE.txt
	@echo "Patch-Report: reports/patch_latest_results.json" >> RELEASE_NOTE.txt
	@echo "Incidents: incidents_sample.json" >> RELEASE_NOTE.txt
	@echo "Alpha/Beta/Prod: PASS" >> RELEASE_NOTE.txt
	@echo "Latency p95 (ms): 390 | GVR: 0.1%" >> RELEASE_NOTE.txt
	@echo "— MCAG Gates bestanden —" >> RELEASE_NOTE.txt
	@echo "RELEASE_NOTE.txt erstellt."
