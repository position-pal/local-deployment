# PositionPal local deployment

This repo contains the docker-compose files to deploy the PositionPal services locally.

> [!WARNING]
> This is meant to be used for development and testing purposes only.
> In production, please refer to the [PositionPal deployment guide using Kubernetes](https://github.com/position-pal/position-pal-terraform).

To deploy the services locally, make sure to have set the following environment variables (either in the shell or in a `.env` file):

- `MAPBOX_API_KEY`: Mapbox API key
- `AKKA_LICENSE_KEY`: Akka license key

and a valid `service-account.json` file is present in the `./secrets` directory.

Run the following command to (un)deploy the services.

```bash
./local-deploy.sh [up|down]
```

Moreover, it is possible to override the images used for the services with the `--override <service-name>:<new-image>` flag.
The script will override the image for the specified `service-name` with the `new-image`.
For example, to use the `local-gateway` and `local-user` images for, respectively, the gateway and user services, run the following command:

```bash
./local-deploy.sh up --override gateway:local-gateway --override user-service:postgres 
```

## Useful links

- [Mermaid docker compose schemas](https://derlin.github.io/docker-compose-viz-mermaid/)
