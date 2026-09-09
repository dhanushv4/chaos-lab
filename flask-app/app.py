from flask import Flask, render_template, Response
import os, psutil, time

app = Flask(__name__)

DATA_PATHS = ["/data/nginx1", "/data/nginx2"]

def stats():
    files = 0
    size = 0

    for path in DATA_PATHS:
        if os.path.exists(path):
            for root, dirs, fs in os.walk(path):
                files += len(fs)
                for f in fs:
                    fp = os.path.join(root, f)
                    if os.path.exists(fp):
                        size += os.path.getsize(fp)

    return files, size


@app.route("/")
def home():
    files, size = stats()

    return render_template("index.html",
        files=files,
        size=size,
        cpu=psutil.cpu_percent(interval=0.5),   # ✅ fix
        mem=psutil.virtual_memory().percent,
        disk=psutil.disk_usage('/').percent
    )


# ✅ Prometheus metrics endpoint (proper format)
@app.route("/metrics")
def metrics():
    files, size = stats()

    cpu = psutil.cpu_percent(interval=0.5)
    mem = psutil.virtual_memory().percent
    disk = psutil.disk_usage('/').percent

    return Response(f"""
# HELP chaos_total_files Total number of files generated
# TYPE chaos_total_files gauge
chaos_total_files {files}

# HELP chaos_total_size_bytes Total size of files in bytes
# TYPE chaos_total_size_bytes gauge
chaos_total_size_bytes {size}

# HELP chaos_cpu_percent CPU usage percentage
# TYPE chaos_cpu_percent gauge
chaos_cpu_percent {cpu}

# HELP chaos_memory_percent Memory usage percentage
# TYPE chaos_memory_percent gauge
chaos_memory_percent {mem}

# HELP chaos_disk_percent Disk usage percentage
# TYPE chaos_disk_percent gauge
chaos_disk_percent {disk}
""", mimetype="text/plain")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
