# ATSD container based on RHEL7 image

## Installation

* Download ```Dockerfile``` to your machine with Red Hat

```
wget https://raw.githubusercontent.com/axibase/dockers/atsd-rhel7/Dockerfile
```

* Make sure your Red Hat is activated and you are able to pull an activated docker image of rhel7

* Build your image

```
docker build -t "axibase/atsd:rhel7" .
```

* Follow the [Docker Installation Guide](https://github.com/axibase/atsd-docs/blob/master/installation/docker.md#start-container) to start container

* Do not forget to change ```axibase/atsd:latest``` to ```axibase/atsd:rhel7``` during the start.

