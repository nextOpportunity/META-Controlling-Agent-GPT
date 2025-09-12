# Service Level Objectives (SLO) – v1

## Business-GPT
- **Availability**: ≥ 99,5 % über 28 Tage
- **p95 Latenz (Text-Turn)**: < 800 ms
- **Fehlerrate**: < 1,0 %
- **Kosten pro 1k Tokens**: ≤ Budget; Alarm bei > 120 % Monatsforecast

## Wissensdatenbank-GPT
- **Antwort-Fachtreffer (eval_score)**: ≥ 0,85 (Holdout)
- **Halluzinations-Rate**: < 2 %
- **PII-Leak**: 0 Vorfälle (Scanner blockt)

## Avatar/Audio-Layer
- **ASR Word Error Rate (WER)**: ≤ 10 % (de-DE)
- **TTS-Antwortstart**: < 300 ms
- **Lip-Sync-Drift**: < 120 ms

## Error-Budget Policy
- Bei Verletzung: Feature-Rollout-Freeze
- Auto-Rollback: bei 2 roten 5-Min-Intervallen
