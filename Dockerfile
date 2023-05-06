FROM node:lts-alpine as build-ui-stage

ENV PROJECT_PATH=/pocketbase
ENV MODE=prod

RUN mkdir -p $PROJECT_PATH
WORKDIR $PROJECT_PATH

COPY ./ui/package*.json $PROJECT_PATH/
RUN npm install

COPY ./ui $PROJECT_PATH
COPY .env* $PROJECT_PATH/
RUN npm run build -- --mode $MODE

FROM golang:1.19.1 as build-go-stage

ENV PROJECT_PATH=/pocketbase

RUN mkdir -p $PROJECT_PATH
COPY . $PROJECT_PATH
WORKDIR $PROJECT_PATH

RUN go mod download
RUN go build -o pocketbase .
RUN chmod +x pocketbase


# Final stage
FROM debian:buster-slim as production

ENV PROJECT_PATH=/pocketbase

RUN apt-get update && \
		apt-get install -y \
		ca-certificates \
		iputils-ping \
		curl \
		procps \
		&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p $PROJECT_PATH
COPY pb_migrations $PROJECT_PATH/pb_migrations
COPY --from=build-ui-stage $PROJECT_PATH/dist $PROJECT_PATH/pb_public
COPY --from=build-go-stage $PROJECT_PATH/pocketbase $PROJECT_PATH
WORKDIR $PROJECT_PATH

RUN chmod +x pocketbase

# USER nobody:nogroup

ENTRYPOINT ["./pocketbase","serve", "--http=0.0.0.0:8090"]