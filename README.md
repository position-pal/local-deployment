# PositionPal local deployment

This repo contains the docker-compose files to deploy the PositionPal services locally.

> [!WARNING]
> This should be used for development and testing purposes only.
> For production deployments, please refer to the [PositionPal deployment guide using Kubernetes](https://github.com/position-pal/helm-charts).

To deploy the services locally, follow the steps below.

```bash
touch .env
echo "MAPBOX_API_KEY=<your_mapbox_api_key>" >> .env
echo "AKKA_LICENSE_KEY=<your_akka_license_key>" >> .env
```

and make sure a valid `service-account.json` file is present in the `./secrets` directory.

Run the following command to (un)deploy the services.

```bash
./local-deploy.sh [up|down]
```

## Useful links

- [Mermaid docker compose schemas](https://derlin.github.io/docker-compose-viz-mermaid/)
