FROM python:3.13-slim

RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir uv

WORKDIR /app
COPY pyproject.toml .
RUN uv pip install --system .

COPY mkdocs.yml .
COPY docs ./docs

CMD ["uv", "run", "mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
