import docker
import sys

def check_containers(excluded_containers):
    client = docker.from_env()
    all_containers = [c for c in client.containers.list(all=True) if c.name not in excluded_containers]
    running_containers = [c for c in all_containers if c.status == 'running']
    if len(running_containers) == len(all_containers):
        print("✅ All containers (excluding specified ones) are running.")
        sys.exit(0)
    else:
        print("❌ Some containers are not running:")
        exited_containers = [c for c in all_containers if c.status in {"exited", "created"}]
        for c in exited_containers:
            print(f"{c.short_id}\t{c.name}\t{c.status}")
        for c in exited_containers:
            print(f"‼️ Logs for container {c.name}:")
            print(c.logs().decode(errors='ignore'))
        sys.exit(1)

if __name__ == "__main__":
    excluded_containers = sys.argv[1:]
    check_containers(excluded_containers)
