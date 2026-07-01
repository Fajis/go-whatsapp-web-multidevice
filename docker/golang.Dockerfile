############################
# STEP 1 build executable binary
############################
FROM golang:1.25-alpine3.21 AS builder
RUN apk update && apk add --no-cache gcc musl-dev gcompat git build-base
WORKDIR /whatsapp
COPY . .
WORKDIR /whatsapp/src
RUN go mod download
RUN CGO_ENABLED=1 GOOS=linux go build -ldflags="-w -s" -o /app/whatsapp

#############################
## STEP 2 build a smaller image
#############################
FROM alpine:3.21
RUN apk add --no-cache ffmpeg libwebp-tools tzdata gcompat
ENV TZ=UTC
WORKDIR /app
COPY --from=builder /app/whatsapp /app/whatsapp
ENTRYPOINT ["/app/whatsapp"]

CMD [ "rest" ]
