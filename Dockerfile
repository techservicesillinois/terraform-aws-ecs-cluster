FROM hashicorp/terraform:0.11.14

RUN apk add make

WORKDIR /tmp
COPY . /tmp

ENTRYPOINT [ "/usr/bin/make", "tfc" ]
