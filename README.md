# S.M.A.R.T.-disk-monitoring-for-Prometheus text collector for docker
### This is custom version of [olegeech-me/S.M.A.R.T-disk-monitoring-for-Prometheus](https://github.com/olegeech-me/S.M.A.R.T-disk-monitoring-for-Prometheus) with:
- Docker support
- NVME drives support

The following dashboards are designed for this exporter:

https://grafana.com/grafana/dashboards/13654

## Purpose
This text collector is a customized version of the S.M.A.R.T. `text_collector` example from `node_exporter` github repo:
https://github.com/prometheus/node exporter/tree/master/text collector examples

## Requirements
- Prometheus
- `node_exporter`
  - text collector enabled for node exporter
- Grafana >= 7.3.6
- Docker

## Set up
To enable text collector set the following flag for `node_exporter`:
- `--collector.textfile.directory=/var/lib/node_exporter/textfile_collector`

To enable the text collector on your system add the following to docker compose.
It will execute the script every five minutes and save the result to the `textfile_collector` directory.

```yaml
smartmon-docker:
  image: ghcr.io/eugene-reim/smartmon-docker:latest
  container_name: smartmon-docker
  privileged: true
  restart: unless-stopped
  volumes:
    - ./node-exporter-text-collector-host-path:/var/lib/node_exporter/textfile_collector
  environment:
    - SMARTMON_INTERVAL=300

```
bind this folder `/var/lib/node_exporter/textfile_collector` to host path where node_exporter is looking for (example `./node-exporter-text-collector-host-path`)

## Example of full installation

```yaml
node_exporter:
  image: "docker.io/quay.io/prometheus/node-exporter:latest"
  container_name: "node_exporter"
  restart: unless-stopped
  volumes:
    - "/:/host:ro"
    - ./node-exporter-text-collector-host-path:/var/lib/node_exporter/textfile_collector # Mounting smartmon-docker output directory to node_exporter
  command:
    - "--path.rootfs=/host"
    - '--collector.textfile.directory=/var/lib/node_exporter/textfile_collector' # Enabling text collector

smartmon-docker:
    image: ghcr.io/eugene-reim/smartmon-docker:latest
    container_name: smartmon-docker
    privileged: true
    restart: unless-stopped
    volumes:
      - ./node-exporter-text-collector-host-path:/var/lib/node_exporter/textfile_collector # Mounting smartmon-docker output directory to host
    environment:
      - SMARTMON_INTERVAL=300

```

