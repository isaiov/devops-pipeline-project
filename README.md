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

## Project Structure

```
├── src/                  # Static website source
│   ├── index.html
│   ├── css/style.css
│   └── js/app.js
├── docker/               # Nginx configuration
├── .github/workflows/    # CI/CD pipelines
├── terraform/            # Infrastructure as Code
├── monitoring/           # Prometheus & Grafana configs
├── Dockerfile
├── docker-compose.yml
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
| 6. Docs | Architecture diagrams | 🔜 Planned |
