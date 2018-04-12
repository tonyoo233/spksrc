#!/bin/sh

## build
# go get github.com/BurntSushi/toml
go build -ldflags "-s -w" -o index.cgi cgi.go

# compress
# upx --brute index.cgi

## test
export REQUEST_METHOD=GET
export SERVER_PROTOCOL=HTTP/1.1
exec ./index.cgi
