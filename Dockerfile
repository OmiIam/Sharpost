# ── builder stage ─────────────────────────────────────────────────────────────
# Installs all dependencies. This layer is not shipped — only its output is.
FROM python:3.12-slim AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --require-hashes --no-cache-dir -r requirements.txt

COPY sharpost/ sharpost/
COPY pyproject.toml .

# ── runtime stage ─────────────────────────────────────────────────────────────
# Minimal image. Only what the app needs to run.
FROM python:3.12-slim AS runtime

# Non-root user — matches securityContext.runAsNonRoot: true in the Helm chart
RUN useradd --uid 1001 --no-create-home --shell /bin/false kubepost

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.12/site-packages \
                    /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/uvicorn
COPY --from=builder /build/sharpost ./sharpost

USER 1001

EXPOSE 8080 9090

HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/healthz')"

CMD ["uvicorn", "sharpost.main:app", "--host", "0.0.0.0", "--port", "8080"]
