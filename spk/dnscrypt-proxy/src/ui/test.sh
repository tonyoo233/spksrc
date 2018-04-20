#!/bin/sh

set -u

urlencode() {
    # https://stackoverflow.com/questions/296536/how-to-urlencode-data-for-curl-command/10797966#10797966
    echo "$1" | curl -Gso /dev/null -w %{url_effective} --data-urlencode @- "" | cut -c 3-
}

# ---------------------------------------------------------------------------

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
data="$(urlencode "$(cat example-dnscrypt-proxy.toml)")"
# echo "$data" > post.html

# echo "ListenAddresses=0.0.0.0%3A1053+&ServerNames=cloudflare+google+ " | ./index.cgi --dev
echo file="$data" | ./index.cgi --dev | tail -n +4 > post.html
sed -i '' -e "s@/webman/3rdparty/dnscrypt-proxy/style\\.css@style\\.css@" post.html
# echo fileName=config&file="$data" | ./index.cgi --dev | tail -n +4 > post.html
# sed -i '' -e "s@/webman/3rdparty/dnscrypt-proxy/style\\.css@style\\.css@" post.html
