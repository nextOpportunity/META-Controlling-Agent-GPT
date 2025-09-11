# MCAG Evaluate – Schnellstart

## Starter-Suite
python scripts/evaluate.py --suite mcag_starter/tests/test_suite.yaml --output reports/starter_results.json

## Patch (lädt automatisch höchste Version)
python scripts/evaluate.py --suite "mcag_phase0_patch/tests/tests_patch_v*.yaml" --output reports/patch_latest_results.json

## Explizit v0
python scripts/evaluate.py --suite mcag_phase0_patch/tests/tests_patch_v0.yaml --output reports/patch_v0_results.json
