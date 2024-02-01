FROM golang:1.22rc2-bookworm as builder

WORKDIR /go/src

RUN apt update && \
    apt install xz-utils && \
    curl -L -o upx.tar.xz https://github.com/upx/upx/releases/download/v4.2.2/upx-4.2.2-amd64_linux.tar.xz && \
    tar -xf upx.tar.xz

COPY ./src .
RUN go build -ldflags "-s -w" && \
    ./upx-4.2.2-amd64_linux/upx hello


FROM scratch

WORKDIR /go/src

COPY --from=builder /go/src/hello .

CMD ["./hello"]