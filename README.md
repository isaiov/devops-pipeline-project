# DevOps Full Pipeline Project

End-to-end DevOps pipeline: static website → Docker → CI/CD → Terraform → Monitoring.

## Architecture

```
Code (HTML/CSS/JS)
  → Docker (Nginx Alpine)
    → GitHub Actions (CI/CD)
      → Terraform (Azure)
        → Prometheus + Grafana (Monitoring)
```

## Quick Start

```bash
# Build and run locally
docker compose up -d

# Open in browser
open http://localhost:8080

# Check health
curl http://localhost:8080/health

# Stop
docker compose down
```

### Full Stack with Monitoring

```bash
# Start everything: site + Prometheus + Grafana
docker compose -f docker-compose.monitoring.yml up -d

# Endpoints:
#   Site       → http://localhost:8080
#   Prometheus → http://localhost:9090
#   Grafana    → http://localhost:3000 (admin / devops123)
#   Health     → http://localhost:8080/health

# Stop
docker compose -f docker-compose.monitoring.yml down
```

## Documentation

- [Architecture](docs/architecture.md) — diagrams: pipeline, monitoring, network
- [Setup Guide](docs/setup-guide.md) — local dev, production deploy, monitoring

## Project Structure

```
├── src/                    # Static website source
│   ├── index.html
│   ├── css/style.css
│   └── js/app.js
├── docker/                 # Nginx configuration
├── .github/workflows/      # CI/CD pipelines
│   ├── ci.yml              #   Build & test on push/PR
│   ├── deploy.yml          #   Auto-deploy to VM
│   └── release.yml         #   Tagged release flow
├── monitoring/             # Observability stack
│   ├── prometheus/         #   Prometheus config + alerts
│   └── grafana/            #   Datasources + dashboards
├── scripts/                # Automation scripts
├── docs/                   # Architecture & setup docs
├── Dockerfile
├── docker-compose.yml          # Dev
├── docker-compose.prod.yml     # Production
├── docker-compose.monitoring.yml # Full stack + monitoring
└── README.md
```

## Phases

| Phase | Description | Status |
|-------|-------------|--------|
| 1. App + Docker | Static site with Nginx container | ✅ Done |
| 2. CI/CD | GitHub Actions pipeline | ✅ Done |
| 3. IaC | Terraform for Azure | 🔜 Planned |
| 4. Deploy | Automated deployment | ✅ Done |
| 5. Monitoring | Prometheus + Grafana | ✅ Done |
| 6. Docs | Architecture diagrams | ✅ Done |
