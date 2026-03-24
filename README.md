# Sharpost

> Engineers currently spend 20 to 45 minutes gathering context from five tools when a Kubernetes alert fires. KubePost eliminates that cold start.

When an AlertManager webhook fires, KubePost automatically collects correlated context from Kubernetes events, pod logs, CloudWatch, Helm history, and Git — then posts a structured incident report and pre-filled runbook to Slack within 60 seconds.

**Status: under active development**

## Quick install
```bash
helm install sharpost ./helm/sharpost \
  --namespace monitoring \
  --set slack.webhookUrl=<your-url> \
  --set llm.provider=ollama
```

## Documentation

Full system design document in `docs/` — architecture, security model, data sources, LLM design.

## Development
```bash
pip install -r requirements-dev.txt
pre-commit install
pytest
```
