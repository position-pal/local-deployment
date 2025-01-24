# PositionPal local deployment

This repo contains the docker-compose files to deploy the PositionPal services locally.

> [!WARNING]
> This should be used for development and testing purposes only.
> For production deployments, please refer to the [PositionPal deployment guide using Kubernetes](https://github.com/position-pal/helm-charts).

To deploy the services locally, make sure to have set the following environment variables (either in the shell or in a `.env` file):

- `MAPBOX_API_KEY`: Mapbox API key
- `AKKA_LICENSE_KEY`: Akka license key

<!--and a valid `service-account.json` file is present in the `./secrets` directory.-->

Run the following command to (un)deploy the services.

```bash
./local-deploy.sh [up|down]
```

## Useful links

- [Mermaid docker compose schemas](https://derlin.github.io/docker-compose-viz-mermaid/)
