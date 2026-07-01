############################
# STEP 1 build executable binary
############################
FROM golang:1.24-alpine3.20 AS builder
RUN apk update && apk add --no-cache gcc musl-dev gcompat git build-base
WORKDIR /whatsapp
COPY . .
RUN go mod download --proto=https
RUN CGO_ENABLED=1 GOOS=linux go build -ldflags="-w -s" -o /app/whatsapp

#############################
## STEP 2 build a smaller image
#############################
FROM alpine:3.20
RUN apk add --no-cache ffmpeg libwebp-tools tzdata gcompat
ENV TZ=UTC
WORKDIR /app
COPY --from=builder /app/whatsapp /app/whatsapp
ENTRYPOINT ["/app/whatsapp"]

CMD [ "rest" ]
