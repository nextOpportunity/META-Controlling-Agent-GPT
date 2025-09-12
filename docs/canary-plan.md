# Canary-Rollout & Auto-Rollback – v1

## Traffic-Splits
- 5 % → 25 % → 100 %

## Blocker-Metriken
- p95 Latenz
- 5xx-Rate
- € pro 1k Tokens
- Safety-Violations

## Alarmierungsziele
- Mean Time to Detect (MTTD): < 5 min (synthetic)
- Rollback-Zeit: < 30 min (Auto-Trigger)

## Rollback-Kriterien
- 2 aufeinanderfolgende 5-Min-Intervalle rot
- Verletzung Error-Budget
