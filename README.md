# docker-electrs

Run mempool on Docker using `bitcoind` on a separate container.
- Original documentation for electrs is available [here](https://github.com/romanz/electrs/blob/a1460ec4a90e45c863c29f66932dd91a0aea9f6f/doc/install.md).
- For running `bitcoind` on Docker, you can use [mu373/docker-bitcoind](https://github.com/mu373/docker-bitcoind).

## Setup
Setup environment variables
```sh
cp config.sample.toml config.toml
vim config.toml # Edit the configuration to fit your needs
```

Start the container
```sh
# Make sure to start bitcoind container *before* starting this mempool container
docker compose up -d
```

Access the shell inside the container
```sh
# In host
docker ps # Check container id
docker exec -it container_id bash
```

See logs
```sh
docker logs --tail 100 container_id
```
