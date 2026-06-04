# Setup Guide

## Prerequisites

- Docker & Docker Compose
- Git
- GitHub account

## Local Development

```bash
# Clone
git clone https://github.com/isaiov/devops-pipeline-project.git
cd devops-pipeline-project

# Run site only
docker compose up -d
# → http://localhost:8080

# Run with monitoring
docker compose -f docker-compose.monitoring.yml up -d
# → Site:       http://localhost:8080
# → Prometheus: http://localhost:9090
# → Grafana:    http://localhost:3000 (admin / devops123)
```

## Production Server Setup

### 1. Prepare the VM

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Verify
docker --version
docker compose version
```

### 2. Configure GitHub Secrets

Go to **Settings → Secrets and variables → Actions** and add:

| Secret | Value |
|--------|-------|
| `SERVER_HOST` | Your VM IP address |
| `SERVER_USER` | SSH username (e.g. `ubuntu`) |
| `SERVER_SSH_KEY` | Private SSH key for the VM |

### 3. Generate SSH Key (if needed)

```bash
# On your local machine
ssh-keygen -t ed25519 -f ~/.ssh/devops-deploy -C "deploy-key"

# Copy public key to VM
ssh-copy-id -i ~/.ssh/devops-deploy.pub user@YOUR_VM_IP

# Add private key content to GitHub Secret SERVER_SSH_KEY
cat ~/.ssh/devops-deploy
```

### 4. Deploy

Push to `main` and the pipeline will automatically:
1. Lint and validate
2. Build Docker image
3. Push to GitHub Container Registry
4. SSH into VM and deploy

### 5. Manual Deploy

```bash
ssh user@YOUR_VM_IP
cd ~/devops-pipeline
./scripts/deploy.sh
```

## Monitoring Setup

### Grafana

1. Open http://YOUR_VM_IP:3000
2. Login: `admin` / `devops123`
3. The "Nginx Overview" dashboard is auto-provisioned
4. **Change the default password** after first login

### Prometheus

1. Open http://YOUR_VM_IP:9090
2. Check **Status → Targets** — all should be UP
3. Check **Alerts** for active alert rules

### Alerting (optional)

To receive alert notifications, add an Alertmanager config:

```yaml
# monitoring/prometheus/prometheus.yml — add:
alerting:
  alertmanagers:
    - static_configs:
        - targets: ["alertmanager:9093"]
```

## Useful Commands

```bash
# View logs
docker compose -f docker-compose.monitoring.yml logs -f web

# Restart a service
docker compose -f docker-compose.monitoring.yml restart prometheus

# Check health
curl http://localhost:8080/health

# View running containers
docker ps

# Stop everything
docker compose -f docker-compose.monitoring.yml down

# Stop and remove volumes
docker compose -f docker-compose.monitoring.yml down -v
```
