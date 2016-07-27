
# Docker image for Varnish HTTP

Varnish is an HTTP accelerator. It is an open source reverse proxy server for HTTP protocol which stores cached pages in virtual memory.

## How to use this image

You do not need to add any data volume until this service only proxies another one.
Main configurations are available as variables (you can see it with `options` command).
You can add your VCL file by `VARNISH_VCL_CONF` variable:

```sh
docker run --name some-varnish -v /my-custom.vcl:/etc/varnish/custom.vcl:ro -e VARNISH_VCL_CONF=/etc/varnish/custom.vcl easycom/varnish
```
