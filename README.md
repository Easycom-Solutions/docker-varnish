# Supported tags and respective `Dockerfile` links
* `3.0.7`, `3x.` [(3.x/Dockerfile)](https://github.com/Easycom-Solutions/docker-varnish/blob/3.x/Dockerfile)
* `4.0.4`, `4.1.6`, `4.1.7`, `4.1.8`, `4.1.9`, `4.1.10`, `4x.` [(4.x/Dockerfile)](https://github.com/Easycom-Solutions/docker-varnish/blob/4.x/Dockerfile)
* `5.0.0`, `5.1.1`, `5.1.2`, `5.1.3`, `5.2.0`, `5.2.1`, `5x.` [(5.x/Dockerfile)](https://github.com/Easycom-Solutions/docker-varnish/blob/5.x/Dockerfile)
* `6.0.1`, `6.0.2`, `6.1.0`, `6.1.1`, `6x.` [(6.x/Dockerfile)](https://github.com/Easycom-Solutions/docker-varnish/blob/6.x/Dockerfile)
 
# How to use this image

You do not need to add any data volume until this service only proxies another one.
Main configurations are available as variables (you can see it with `options` command).
You can add your VCL file by `VARNISH_VCL_CONF` variable:

```sh
docker run --name some-varnish -v /my-custom.vcl:/etc/varnish/custom.vcl:ro -e VARNISH_VCL_CONF=/etc/varnish/custom.vcl easycom/varnish
```
 
 
# Use with docker-compose

This configuration has been tested with turpentine for Magento 1.x

```yaml
version: '2'
services:
  varnish:
    image: easycom/varnish:3.x
    links: 
      - web:backend # Nota : web is another container of the docker-compose.yml file (excluded of this sample)
    volumes:
      - ./docker-conf/varnish/varnish.vcl:/etc/varnish/default.vcl:ro
      - ./docker-conf/varnish/secret:/etc/varnish/secret:ro
      - /etc/localtime:/etc/localtime:ro
    environment:
      - VARNISH_ADMIN_LISTEN_ADDRESS=0.0.0.0 # Allow to admin from another container, like magento cms
      - VARNISH_VCL_CONF=/etc/varnish/default.vcl
      - VARNISH_SECRET_FILE=/etc/varnish/secret
      - VARNISH_CUSTOM_OPTIONS=-p esi_syntax=0x0 -p cli_buffer=20000 -p sess_workspace=65536

```
