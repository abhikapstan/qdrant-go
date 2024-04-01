# syntax=docker/dockerfile:1

FROM golang:1.20 AS build-stage

# Set destination for COPY
WORKDIR /app

# Download Go modules
COPY go.mod ./
RUN go mod download
# Copy the source code. Note the slash at the end, as explained in
# https://docs.docker.com/engine/reference/builder/#copy
COPY *.go ./
RUN go get qdrant-test


# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /qdrant-test

FROM debian:buster-slim AS build-release-stage

WORKDIR /

COPY --from=build-stage /qdrant-test /qdrant-test

RUN apt-get update && apt-get install -y bash curl

ENTRYPOINT ["/bin/bash", "-c", "/qdrant-test"]
