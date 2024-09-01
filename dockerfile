# ビルド用のステージ
FROM golang:1.20-alpine3.17 AS builder

RUN apk update && apk add --no-cache sqlite

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

# アーキテクチャを指定してビルド
RUN GOARCH=arm64 go build -o server

# 最終ステージ
FROM alpine:3.17

WORKDIR /app

COPY --from=builder /app/server .

EXPOSE 8080

CMD ["./server"]
