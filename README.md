# docker-electrs

Run [romanz/electrs](https://github.com/romanz/electrs) on Docker using `bitcoind` on a separate container.
- Original documentation for electrs is available [here](https://github.com/romanz/electrs/blob/a1460ec4a90e45c863c29f66932dd91a0aea9f6f/doc/install.md).
- For running `bitcoind` on Docker, you can use [mu373/docker-bitcoind](https://github.com/mu373/docker-bitcoind).

## Setup
Setup `docker-compose.yml` and environment variables
```sh
cp docker-compose-template.yml docker-compose.yml
cp config.sample.toml config.toml
vim config.toml # Edit the configuration to fit your needs
```

Start the container
```sh
# Make sure to start bitcoind container *before* starting this electrs container
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

# It should show logs something like this
# Starting electrs 0.10.0 on x86_64 linux with Config { network: Bitcoin, db_path: "/electrs/data/bitcoin", daemon_dir: "/data/.bitcoin", daemon_auth: UserPass("root", "<sensitive>"), daemon_rpc_addr: 192.168.128.2:8332, daemon_p2p_addr: 192.168.128.2:8333, electrum_rpc_addr: 127.0.0.1:50001, monitoring_addr: 127.0.0.1:4224, wait_duration: 10s, jsonrpc_timeout: 15s, index_batch_size: 10, index_lookup_limit: None, reindex_last_blocks: 0, auto_reindex: true, ignore_mempool: false, sync_once: false, skip_block_download_wait: false, disable_electrum_rpc: false, server_banner: "Welcome to electrs 0.10.0 (Electrum Rust Server)!", signet_magic: e3cdb3a1, args: [] }
# [2023-08-14T05:16:29.430Z INFO  electrs::metrics::metrics_impl] serving Prometheus metrics on 127.0.0.1:4224
# [2023-08-14T05:16:29.430Z INFO  electrs::server] serving Electrum RPC on 127.0.0.1:50001
# ...
# [2023-08-14T05:36:55.049Z INFO  electrs::index] indexing 2000 blocks: [589681..591680]
# [2023-08-14T05:37:37.995Z INFO  electrs::chain] chain updated: tip=0000000000000000001eba1320x7f2312b, height=591680
# [2023-08-14T05:37:37.999Z INFO  electrs::index] indexing 2000 blocks: [591681..593680]
```


## SSL connection
By setting your own SSL certificate, electrs can be served through SSL at port 50002. [nginx](https://hub.docker.com/_/nginx) is used as the reverse proxy. If you do not prefer to use SSL, you can simply enable the binding setting for port 50001 in `docker-compose.yml`.

- `/nginx/nginx.conf`
    - Modified version of the default configuration file
    - This file is binded to `/etc/nginx/nginx.conf` in the container.
    - `include /etc/nginx/conf.stream.d/*.conf` has been added to add SSL support to electrs. (c.f. [(link)](https://serverfault.com/questions/1077988/nginx-does-not-open-specified-listen-port) )
- `/nginx/conf.stream.d/electrs.conf`
    - Configuration file to add SSL support to electrs.
    - See the original documentation from romanz/electrs for details [(link)](https://github.com/romanz/electrs/blob/a1460ec4a90e45c863c29f66932dd91a0aea9f6f/doc/config.md#ssl-connection).
- Install your SSL certificate at the root directory, or change the bind settings in `docker-compose.yml`.

## Usage
Your electrs node should be available at https://localhost:50002 (when using SSL).