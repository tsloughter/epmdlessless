epmdlessless
=====

This example project is part of blog post [Running Erlang Releases without EPMD on OTP 23.1+](https://blog.erlware.org/epmdlessless/).

## Build and Run

A `docker-compose.yml` file is provided, along with a `Dockerfile`, which will
build the Docker image and start 3 nodes (`node_a`, `node_b`, `node_c`). Simply
run `up` to build the images and start the 3 nodes:

``` shell
$ docker-compose up
```

## Clustering Nodes

Use `docker exec` to open a remote shell on `node_a` and connect to `node_b`:

``` shell
$ docker exec -ti node_a bin/epmdlessless remote_console
Erlang/OTP 23 [erts-11.1.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Eshell V11.1.3  (abort with ^G)
(epmdlessless@node_a)1> net_kernel:connect_node(epmdlessless@node_b).
true
(epmdlessless@node_a)2> nodes().
[epmdlessless@node_b]
```

Do the same on `node_c` and also connect to `node_b` and you'll see the full
mesh is created with `node_a`:

``` shell
$ docker exec -ti node_c bin/epmdlessless remote_console
Erlang/OTP 23 [erts-11.1.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Eshell V11.1.3  (abort with ^G)
(epmdlessless@node_c)1> net_kernel:connect_node(epmdlessless@node_b).
true
(epmdlessless@node_c)2> nodes().
[epmdlessless@node_b,epmdlessless@node_a]
```

