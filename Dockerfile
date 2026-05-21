FROM python:3.12.2-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends \
        gcc \
        libpq-dev \
        build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip setuptools wheel

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get purge -y gcc libpq-dev build-essential && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . .

RUN useradd -m -u 10001 appuser

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]