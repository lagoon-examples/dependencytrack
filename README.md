# Example Dependency Track for Lagoon

> [!WARNING]
> This is provided as is with no support. While this does deploy an instance of Dependency Track, this has not been used in production, and careful testing should be performed before doing so.
> We welcome all contributions from community members to help us improve this example and bring it up to a supported capacity.

## Local development

Running just the `docker-compose.yaml` file locally with `docker compose` will result in a running Dependency Track example that is as close to what would be deployed with Lagoon.

```bash
docker pull uselagoon/commons
docker pull uselagoon/postgres-17
docker pull dependencytrack/frontend
docker pull dependencytrack/apiserver
docker compose up -d --build
```

## Running Dependency Track locally

Visit [localhost:8080](http://localhost:8080) to access the Dependency Track frontend.

Visit the [documentation](https://docs.dependencytrack.org/) for instructions on how to run the project.

## Running Dependency Track on Lagoon

Note that for the frontend to successfully communicate with the backend, a runtime environment variable called `API_BASE_URL` should be created that points to the ingress associated with the API.

Future iterations of the entrypoints should be able to have an educated guess at what this should be.
