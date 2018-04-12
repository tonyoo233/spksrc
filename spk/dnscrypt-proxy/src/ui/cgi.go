package main

import (
    "fmt"
    "net/http/cgi"
    "html/template"
    "net/http"
    "github.com/BurntSushi/toml"
)

type PageData struct {
    Title string
    ListenAddresses []string
}

// ref: https://github.com/jedisct1/dnscrypt-proxy/blob/master/dnscrypt-proxy/config.go
type Config struct {
    Title string
    ListenAddresses []string `toml:"listen_addresses"`
    ServerNames []string `toml:"server_names"`
    SourceIPv6 bool `toml:"ipv6_servers"`
}

var dev = false

func cgihandler(w http.ResponseWriter, r *http.Request) {

    header := w.Header()
    // header.Set("Content-Type", "text/plain; charset=utf-8") // when something goes wrong
    header.Set("Content-Type", "text/html; charset=utf-8")

    var conf Config
    // if _, err := toml.DecodeFile("example-dnscrypt-proxy.toml", &conf); err != nil { // for development
    if _, err := toml.DecodeFile("/var/packages/dnscrypt-proxy/target/var/dnscrypt-proxy.toml", &conf); err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    tmpl, err := template.ParseFiles("layout.html")
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    conf.Title = "DNSCrypt-proxy"
    tmpl.Execute(w, conf)
}

func main() {
    // Todo:
    // Check authorisation!!
    // check for csrf token
    // parse POST params
    // save changes
    // fix image icons, not sure what up with them
    // Done:
    // get settings from config file
    if err := cgi.Serve(http.HandlerFunc(cgihandler)); err != nil {
        fmt.Println(err)
    }
}
