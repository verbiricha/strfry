<h1 align="center">strfry-docker<br />
<div align="center">
<img src="https://raw.githubusercontent.com/dockur/strfry/master/docs/strfry.svg" title="Logo" style="max-width:100%;" width="256" />
</div>
<div align="center">
  
[![Build]][build_url]
[![Version]][tag_url]
[![Size]][tag_url]
[![Pulls]][hub_url]

</div></h1>

Docker image of [strfry](https://github.com/hoytech/strfry), a relay for the [nostr](https://github.com/nostr-protocol/nostr) protocol.

## How to use

Via `docker-compose`

```yaml
version: "3"
services:
  strfry:
    container_name: strfry
    image: dockurr/strfry:latest
    environment:
            STREAMS: "relayable.org,relay.damus.io"
    ports:
        - 7777:7777
    volumes:
        - /path/to/strfry-db:/app/strfry-db
        - /path/to/strfry.conf:/etc/strfry.conf
```

[build_url]: https://github.com/dockur/strfry/
[hub_url]: https://hub.docker.com/r/dockurr/strfry/
[tag_url]: https://hub.docker.com/r/dockurr/strfry/tags

[Build]: https://github.com/dockur/strfry/actions/workflows/build.yml/badge.svg
[Size]: https://img.shields.io/docker/image-size/dockurr/strfry/latest?color=066da5&label=size
[Pulls]: https://img.shields.io/docker/pulls/dockurr/strfry.svg?style=flat&label=pulls&logo=docker
[Version]: https://img.shields.io/docker/v/dockurr/strfry/latest?arch=amd64&sort=semver&color=066da5
