FROM golang:1.16-buster AS builder
COPY go.mod /tmp/src/
COPY go.sum /tmp/src/
WORKDIR /tmp/src/
RUN go mod download
COPY . /tmp/src/
RUN go test ./...
ARG VERSION=unknown
RUN go install -mod=readonly -ldflags "-X main.version=$VERSION" /tmp/src

FROM debian:buster
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /go/bin/vizares-pg-agent /usr/bin/vizares-pg-agent
ENTRYPOINT ["vizares-pg-agent"]
