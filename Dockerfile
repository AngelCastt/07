FROM golang:1.23.0 as build
WORKDIR /app
COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build cmd/main.go

RUN go build cmd/main.go

FROM alpine:3.18

RUN apk --no-cahce add ca-certificates

WORKDIR /roo/

COPY --from=build /app/main ./
COPY --from=build /app/cmd/templates ./templates

CMD ["./main"]
