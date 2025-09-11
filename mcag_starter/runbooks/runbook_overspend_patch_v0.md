# Overspend-Alert Runbook

## 1. Erkennen
- Alert: overspend-detected
- Quelle: Billing Export, SLO breach (cost_per_request_eur oder budget deviation)

## 2. Eindämmen (15 Min)
- Canary-Traffic reduzieren auf 10 %
- Deaktiviere experimentelle Modelle (teuerste zuerst)
- Priorität: kritische GPTs → bleiben live

## 3. Diagnostik
- Vergleiche Kosten pro Modellvariante (€/Req)
- Prüfe Routing-Weights im Experiment-Manager
- Prüfe API-Quoten (mögliche Preiserhöhung)

## 4. Beheben
- Wenn Modellkosten zu hoch: Traffic umleiten auf günstigere Varianten
- Bei externen APIs: Alternative Endpoints aktivieren oder Retry-Limits
- Budget-Grenzen in configs/connectors.yaml anpassen

## 5. Nachbereitung (24 h)
- RCA (Kostenanstieg: Modellwahl, API-Preis, Drift?)
- Update SLOs/Kostenannahmen
- Dokumentation im Incident-Log
