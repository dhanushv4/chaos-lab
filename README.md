# 🔥 Chaos Lab — Docker Chaos Engineering & Monitoring

A Docker-based Chaos Engineering and Observability project designed to simulate **CPU, memory, disk, and file/inode stress** while monitoring the system using **Prometheus, Grafana, Node Exporter, and cAdvisor**.

---

## 🏗️ Architecture

```text
                    ┌─────────────────────┐
                    │       Grafana       │
                    │   Visualization     │
                    │     Port: 3000      │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │     Prometheus      │
                    │   Metrics Storage   │
                    │     Port: 9090      │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼─────────────────┐
              │                │                 │
              ▼                ▼                 ▼
        ┌──────────┐     ┌────────────┐    ┌───────────┐
        │  Flask   │     │   Node     │    │ cAdvisor  │
        │  :5000   │     │ Exporter   │    │   :8080   │
        └────┬─────┘     │   :9100    │    └───────────┘
             │           └────────────┘
             │
       ┌─────┴─────┐
       ▼           ▼
 ┌──────────┐ ┌──────────┐
 │  Nginx1  │ │  Nginx2  │
 │  :8081   │ │  :8082   │
 └──────────┘ └──────────┘
       │           │
       ▼           ▼
   real-data/  real-data/
    nginx1       nginx2
```

---

## 📁 Project Structure

```text
chaos-lab/
│
├── docker-compose.yaml
│
├── flask-app/
│   ├── Dockerfile
│   ├── app.py
│   ├── requirements.txt
│   └── templates/
│       └── index.html
│
├── nginx/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── stress.sh
│
├── prometheus/
│   └── prometheus.yml
│
├── real-data/
│   ├── nginx1/
│   └── nginx2/
│
├── .gitignore
└── README.md
```

---

# 🚀 Technologies Used

* Docker
* Docker Compose
* NGINX
* Python
* Flask
* psutil
* Prometheus
* Grafana
* Node Exporter
* cAdvisor
* Bash
* Linux

---

# 🎯 Project Objectives

This project demonstrates:

* Docker containerization
* Chaos Engineering concepts
* CPU stress testing
* Memory stress testing
* Disk usage simulation
* File/inode generation
* Application metrics
* Prometheus scraping
* Grafana visualization
* Docker container monitoring
* Infrastructure monitoring
* Observability

---

# ⚙️ Prerequisites

Install:

* Docker
* Docker Compose
* Git
* Linux / WSL2 recommended

Verify Docker:

```bash
docker --version
```

Verify Compose:

```bash
docker compose version
```

---

# 📥 Clone the Repository

```bash
git clone <YOUR-GITHUB-REPOSITORY-URL>
```

```bash
cd chaos-lab
```

---

# 📂 Create Data Directories

Create the directories used by the NGINX containers:

```bash
mkdir -p real-data/nginx1
mkdir -p real-data/nginx2
```

Verify:

```bash
ls -R real-data
```

Expected:

```text
real-data/
├── nginx1/
└── nginx2/
```

---

# 🐳 Build and Start the Project

Run:

```bash
docker compose up --build
```

To run in the background:

```bash
docker compose up --build -d
```

Check running containers:

```bash
docker ps
```

Expected containers:

```text
nginx1
nginx2
flask-app
prometheus
grafana
node-exporter
cadvisor
```

---

# 🌐 Application Endpoints

| Service       | URL                           |
| ------------- | ----------------------------- |
| NGINX 1       | http://localhost:8081         |
| NGINX 2       | http://localhost:8082         |
| Flask         | http://localhost:5000         |
| Flask Metrics | http://localhost:5000/metrics |
| Prometheus    | http://localhost:9090         |
| Grafana       | http://localhost:3000         |
| cAdvisor      | http://localhost:8080         |
| Node Exporter | http://localhost:9100/metrics |

---

# 🧪 Test NGINX

Open:

```text
http://localhost:8081
```

Expected:

```text
Nginx Chaos Running
```

Test NGINX 2:

```text
http://localhost:8082
```

---

# 📊 Flask Monitoring

The Flask application exposes custom Prometheus metrics.

Endpoint:

```bash
curl http://localhost:5000/metrics
```

Expected metrics:

```text
chaos_total_files
chaos_total_size_bytes
chaos_cpu_percent
chaos_memory_percent
chaos_disk_percent
```

---

# 📈 Prometheus

Open:

```text
http://localhost:9090
```

Go to:

```text
Status → Target health
```

The following targets should be `UP`:

```text
flask
node
cadvisor
```

---

# 🔎 Prometheus Queries

Test Flask CPU:

```promql
chaos_cpu_percent
```

Memory:

```promql
chaos_memory_percent
```

Disk:

```promql
chaos_disk_percent
```

Number of files:

```promql
chaos_total_files
```

Total file size:

```promql
chaos_total_size_bytes
```

---

# 📊 Grafana

Open:

```text
http://localhost:3000
```

Default credentials:

```text
Username: admin
Password: admin123
```

---

# 🔗 Add Prometheus to Grafana

In Grafana:

```text
Connections
    ↓
Data Sources
    ↓
Add data source
    ↓
Prometheus
```

Use:

```text
http://prometheus:9090
```

Then select:

```text
Save & Test
```

---

# 📊 Recommended Grafana Dashboard

Create panels for:

### CPU

```promql
chaos_cpu_percent
```

### Memory

```promql
chaos_memory_percent
```

### Disk

```promql
chaos_disk_percent
```

### Files

```promql
chaos_total_files
```

### File Size

```promql
chaos_total_size_bytes
```

For file size, use a bytes unit.

---

# 🔥 Chaos Engineering

The `stress.sh` script continuously generates system activity.

It performs:

### 1. Disk Write

```bash
echo "$(date) - writing data $RANDOM" >> $FILE
```

This continuously writes data.

### 2. File Generation

```bash
touch "$DATA_DIR/inode_$i"
```

This creates many files.

### 3. CPU Activity

```bash
gzip -c $FILE > "$FILE.gz"
```

Compression creates CPU workload.

### 4. Memory Stress

```bash
stress --vm 1 --vm-bytes 50M --timeout 5
```

This temporarily consumes memory.

### 5. Decompression

```bash
gunzip -f "$FILE.gz"
```

This generates additional CPU and disk activity.

---

# 📁 Monitoring Generated Data

Check:

```bash
du -sh real-data/nginx1
```

and:

```bash
du -sh real-data/nginx2
```

Count files:

```bash
find real-data/nginx1 -type f | wc -l
```

```bash
find real-data/nginx2 -type f | wc -l
```

---

# 🐳 Docker Container Monitoring

cAdvisor provides container-level metrics.

Open:

```text
http://localhost:8080
```

Prometheus also collects cAdvisor metrics.

Example query:

```promql
container_memory_usage_bytes
```

Container CPU:

```promql
rate(container_cpu_usage_seconds_total[5m])
```

---

# 🖥️ Host Monitoring

Node Exporter exposes Linux system metrics.

Endpoint:

```text
http://localhost:9100/metrics
```

Example Prometheus query:

```promql
node_cpu_seconds_total
```

Memory:

```promql
node_memory_MemAvailable_bytes
```

Disk:

```promql
node_filesystem_avail_bytes
```

---

# 🛑 Stop the Project

If running in the foreground:

```text
Ctrl + C
```

Or:

```bash
docker compose down
```

---

# 🧹 Remove Containers

```bash
docker compose down
```

To remove containers and associated anonymous resources:

```bash
docker compose down --remove-orphans
```

---

# 🔄 Rebuild From Scratch

If you modify the Dockerfiles:

```bash
docker compose down
```

Then:

```bash
docker compose build --no-cache
```

Then:

```bash
docker compose up
```

---

# 🐞 Troubleshooting

### Check all containers

```bash
docker ps -a
```

### Check Flask logs

```bash
docker logs flask-app
```

### Check NGINX logs

```bash
docker logs nginx1
```

```bash
docker logs nginx2
```

### Check Prometheus logs

```bash
docker logs prometheus
```

### Check Grafana logs

```bash
docker logs grafana
```

### Check Flask metrics

```bash
curl http://localhost:5000/metrics
```

### Check Prometheus target connectivity

```text
http://localhost:9090/targets
```

---

# 🏆 Learning Outcomes

After completing this project, you should understand:

* Docker Compose
* Container networking
* Docker volumes
* Resource stress testing
* Linux system monitoring
* Application monitoring
* Prometheus metrics
* Prometheus scraping
* Grafana dashboards
* Node Exporter
* cAdvisor
* Observability
* Basic Chaos Engineering

---

# 🔮 Future Improvements

Possible improvements:

* Add Alertmanager
* Add CPU alerts
* Add memory alerts
* Add disk alerts
* Add Slack/Email notifications
* Add Docker health checks
* Add Kubernetes deployment
* Add Argo CD GitOps deployment
* Add CI/CD using GitHub Actions
* Add Terraform infrastructure
* Add AWS deployment
* Add automated chaos experiments

---

# 👨‍💻 Author

**Dhanush**

Cloud & DevOps Learning Project

Focus:

```text
AWS
Docker
Kubernetes
Terraform
Linux
CI/CD
Prometheus
Grafana
Chaos Engineering
```

