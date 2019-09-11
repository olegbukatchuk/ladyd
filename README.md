# ladyd
This is `cron` in `docker` with `json` configuration file. A simple wrapper over `docker` to all complex cron job to be run in other containers.

## How to use

### Command Line

```bash
docker build -t cron .
docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /path/to/config/dir:/opt/cron:rw \
    -v /path/to/logs:/var/log/cron:rw \
    cron
```

### Use with docker-compose

1. Figure out which network name used for your docker-compose containers
	* use `docker network ls` to see existing networks
	* if your `docker-compose.yaml` is in `my_dir` directory, you probably has network `my_dir_default`
	* otherwise [read the docker-compose docs](https://docs.docker.com/compose/networking/)
2. Add `dockerargs` to your docker-cron `config.json`
	* use `--network NETWORK_NAME` to connect new container into docker-compose network
	* use `--rm --name NAME` to use named container
	* e.g. `"dockerargs": "--network my_dir_default --rm --name my-cron-job"`

### config.json
- `name`: Human readable name that will be used as the job filename. Will be converted into a slug. **Optional**
- `comment`: Comments to be included with crontab entry. **Optional**
- `schedule`: Crontab schedule syntax as described in https://en.wikipedia.org/wiki/Cron. Examples: `@hourly`, `@every 1h30m`, `* * * * *`. **Required**
- `command`: Command to be run on in crontab container or docker container/image. Required.
- `image`: Docker images name (ex `library/alpine:3.5`). **Optional**
- `project`: Docker Compose/Swarm project name. **Optional**, only applies when `contain` is included.
- `container`: Full container name or container alias if `project` is set. Ignored if `image` is included. **Optional**
- `dockerargs`: Command line docker `run`/`exec` arguments for full control. Defaults to ` `.
- `trigger`: Array of docker-crontab subset objects. Subset includes: `image`, `project`, `container`, `command`, `dockerargs`.
- `onstart`: Run the command on `cron` container start, set to `true`. **Optional**, defaults to false.

See [`config.sample.json`](https://github.com/olegbukatchuk/ladyd/blob/master/config.sample.json) for examples.

## Docker Hub

See image in [registry](https://hub.docker.com/r/olegbukatchuk/).
