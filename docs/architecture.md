# Architecture

## High-Level Overview

```
┌─────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Developer   │────▶│   GitHub Repo    │────▶│  GitHub Actions  │
│  (git push)  │     │  (main branch)   │     │   CI Pipeline    │
└─────────────┘     └──────────────────┘     └────────┬────────┘
                                                       │
                                              ┌────────▼────────┐
                                              │   Build & Test   │
                                              │  - Lint HTML     │
                                              │  - Lint Docker   │
                                              │  - Build image   │
                                              │  - Health check  │
                                              └────────┬────────┘
                                                       │
                                              ┌────────▼────────┐
                                              │  Push to GHCR    │
                                              │  (Docker image)  │
                                              └────────┬────────┘
                                                       │
                                              ┌────────▼────────┐
                                              │  Deploy via SSH  │
                                              │  (Production VM) │
                                              └────────┬────────┘
                                                       │
                    ┌──────────────────────────────────┐│
                    │         Production Server         ││
                    │                                   ▼│
                    │  ┌───────────────────────────────┐ │
                    │  │  Docker: devops-pipeline-web   │ │
                    │  │  (Nginx Alpine — port 80)      │ │
                    │  └──────────┬────────────────────┘ │
                    │             │                       │
                    │  ┌──────────▼────────────────────┐ │
                    │  │  Nginx Exporter (:9113)        │ │
                    │  └──────────┬────────────────────┘ │
                    │             │                       │
                    │  ┌──────────▼────────────────────┐ │
                    │  │  Node Exporter (:9100)         │ │
                    │  └──────────┬────────────────────┘ │
                    │             │                       │
                    │  ┌──────────▼────────────────────┐ │
                    │  │  Prometheus (:9090)            │ │
                    │  │  - Scrape metrics              │ │
                    │  │  - Evaluate alerts             │ │
                    │  └──────────┬────────────────────┘ │
                    │             │                       │
                    │  ┌──────────▼────────────────────┐ │
                    │  │  Grafana (:3000)               │ │
                    │  │  - Nginx dashboard             │ │
                    │  │  - Host metrics                │ │
                    │  └───────────────────────────────┘ │
                    └────────────────────────────────────┘
```

## CI/CD Pipeline Flow

```
 Push to main          Pull Request
      │                      │
      ▼                      ▼
 ┌─────────┐           ┌─────────┐
 │  Lint   │           │  Lint   │
 └────┬────┘           └────┬────┘
      ▼                      ▼
 ┌─────────┐           ┌─────────┐
 │  Build  │           │  Build  │
 │ & Test  │           │ & Test  │
 └────┬────┘           └─────────┘
      ▼                  (no push)
 ┌─────────┐
 │  Push   │
 │ to GHCR │
 └────┬────┘
      ▼
 ┌─────────┐
 │ Deploy  │
 │  to VM  │
 └─────────┘
```

## Monitoring Stack

```
┌──────────┐    scrape     ┌────────────┐    query    ┌─────────┐
│  Nginx   │◀──────────────│ Prometheus │◀────────────│ Grafana │
│ Exporter │   /stub_status│            │  PromQL     │         │
└──────────┘               │  Alerts:   │             │ Panels: │
                           │  - Down    │             │ - Status│
┌──────────┐    scrape     │  - 5xx     │             │ - RPS   │
│  Node    │◀──────────────│  - Memory  │             │ - CPU   │
│ Exporter │  /metrics     │  - Disk    │             │ - Memory│
└──────────┘               └────────────┘             └─────────┘
```

## Network

All services communicate via the `monitoring` Docker bridge network.

| Service | Internal Port | External Port |
|---------|--------------|---------------|
| Web (Nginx) | 80 | 8080 (dev) / 80 (prod) |
| Nginx Exporter | 9113 | 9113 |
| Node Exporter | 9100 | 9100 |
| Prometheus | 9090 | 9090 |
| Grafana | 3000 | 3000 |

## Release Flow

```
git tag v1.0.0 → push tag → GitHub Actions:
  1. Build image with version tag
  2. Push to GHCR (ghcr.io/isaiov/devops-pipeline-project:v1.0.0)
  3. Create GitHub Release with auto-generated notes
```
