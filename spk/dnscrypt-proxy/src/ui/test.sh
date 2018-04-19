#!/bin/sh

# set -x
set -u

## build
# go get github.com/BurntSushi/toml
go build -ldflags "-s -w" -o index.cgi cgi.go

# compress
# upx --brute index.cgi

## test
export REQUEST_METHOD=GET
export SERVER_PROTOCOL=HTTP/1.1
./index.cgi --dev | tail -n +4 > index.html
sed -i '' -e "s@/webman/3rdparty/dnscrypt-proxy/style\\.css@style\\.css@" index.html

export REQUEST_METHOD=POST
data="$(cat example-dnscrypt-proxy.toml)"
# echo "ListenAddresses=0.0.0.0%3A1053+&ServerNames=cloudflare+google+ " | ./index.cgi --dev
echo file="$data" | ./index.cgi --dev | tail -n +4 > post.html
sed -i '' -e "s@/webman/3rdparty/dnscrypt-proxy/style\\.css@style\\.css@" post.html
# echo fileName=config&file="$data" | ./index.cgi --dev | tail -n +4 > post.html
# sed -i '' -e "s@/webman/3rdparty/dnscrypt-proxy/style\\.css@style\\.css@" post.html
