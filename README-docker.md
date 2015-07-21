# RVI on Docker

See [PDXostc/rvi_core](https://github.com/PDXostc/rvi_core) for documentation on
RVI.

## Development node

### Quickstart

To quickly spin up a development RVI node, with the [default
configuration](https://github.com/PDXostc/rvi_core/blob/master/rvi_sample.config)
and disabled bluetooth run:

```sh
docker run -d -p 8801:8801 -p 8807:8807 advancedtelematic/rvi:dev
```

### Configuration

You can link in your own configuration like this:

```sh
docker run -it \
  -p 8801:8801 \
  -p 8807:8807 \
  --volume $PWD/your-configuration.conf:/rvi/dev.conf:ro \
  advancedtelematic/rvi:dev
```

If you want to store it at a different place you can run

```sh
docker run -it \
  -p 8801:8801 \
  -p 8807:8807 \
  -e CONFIGURATION=/some/path.conf \
  --volume $PWD/your-configuration.conf:/some/path.conf:ro \
  advancedtelematic/rvi:dev
```
