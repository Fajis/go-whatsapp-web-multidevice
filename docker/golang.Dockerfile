############################
# STEP 1 build executable binary
############################
FROM golang:1.24-alpine3.20 AS builder
RUN apk update && apk add --no-cache gcc musl-dev gcompat git build-base
WORKDIR /whatsapp
COPY . .
WORKDIR /whatsapp/src

# Fetch dependencies.
RUN go mod download
# Build the binary with optimizations
RUN CGO_ENABLED=1 GOOS=linux go build -ldflags="-w -s -extldflags '-static'" -o /app/whatsapp

#############################
## STEP 2 build a smaller image
#############################
FROM alpine:3.20
RUN apk add --no-cache ffmpeg libwebp-tools tzdata
ENV TZ=UTC
WORKDIR /app
# Copy compiled from builder.
COPY --from=builder /app/whatsapp /app/whatsapp
# Run the binary.
ENTRYPOINT ["/app/whatsapp"]

CMD [ "rest" ]
