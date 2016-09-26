
## Build image

    docker build -t platform-unoconv .

## Create local network for docker dns

    docker network create protonet

## Run unoconv listener with examples volume mounted

    docker run -it --rm -v $(pwd)/examples:/examples --name platform-unoconv --network protonet platform-unoconv

## Run unoconv

### From separate container, cannot connect:

    docker run -it --rm -v $(pwd)/examples:/examples --entrypoint bash --network protonet platform-unoconv
    # Inside the shell
    unoconv --port 2002 --server unoconv -f pdf -vvvv /examples/wd-spectools-word-sample-04.doc

### From same container listener is running in:

    docker exec -it platform-unoconv bash
    # Inside the shell
    unoconv --port 2002 --server localhost -f pdf -vvvv /examples/wd-spectools-word-sample-04.doc