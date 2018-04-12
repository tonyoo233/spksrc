package main

import (
    "fmt"
    "os"
    "os/exec"
    "errors"
    // "net/http/cgi"
    "html/template"
    // "net/http"
    "regexp"
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

// func cgihandler(w http.ResponseWriter, r *http.Request) {

//     header := w.Header()
//     // header.Set("Content-Type", "text/plain; charset=utf-8") // when something goes wrong
//     header.Set("Content-Type", "text/html; charset=utf-8")

//     var conf Config
//     // if _, err := toml.DecodeFile("example-dnscrypt-proxy.toml", &conf); err != nil { // for development
//     if _, err := toml.DecodeFile("/var/packages/dnscrypt-proxy/target/var/dnscrypt-proxy.toml", &conf); err != nil {
//         http.Error(w, err.Error(), http.StatusInternalServerError)
//         return
//     }

//     tmpl, err := template.ParseFiles("layout.html")
//     if err != nil {
//         http.Error(w, err.Error(), http.StatusInternalServerError)
//         return
//     }

//     conf.Title = "DNSCrypt-proxy"
//     tmpl.Execute(w, conf)
// }

func renderhtml() {
    var conf Config
    // if _, err := toml.DecodeFile("example-dnscrypt-proxy.toml", &conf); err != nil { // for development
    if _, err := toml.DecodeFile("/var/packages/dnscrypt-proxy/target/var/dnscrypt-proxy.toml", &conf); err != nil {
        fmt.Println(err)
        return
    }

    tmpl, err := template.ParseFiles("layout.html")
    if err != nil {
        fmt.Println(err)
        return
    }

    conf.Title = "DNSCrypt-proxy"
    tmpl.Execute(os.Stdout, conf)
    if err != nil { panic(err) }
}

func token() (string, error) {
    cmd := exec.Command("/usr/syno/synoman/webman/login.cgi")
    cmdOut, err := cmd.Output()
    if err != nil && err.Error() != "exit status 255" { // in the Synology world, error code 255 apparently means success!
        return string(cmdOut), err
    }

    // Content-Type: text/html [..] { "SynoToken" : "GqHdJil0ZmlhE", "result" : "success", "success" : true }
    r := regexp.MustCompile("SynoToken\" *: *\"([^\"]+)\"")
    token := r.FindSubmatch(cmdOut)
    if len(token) < 1 {
        return "", errors.New("no token found!")
    }
    return string(token[1]), nil
}

func auth() (string) {
    token, err := token()
     if err != nil {
        dd(err.Error())
        // Todo return 404
        // Todo return 401
    }

    // X-SYNO-TOKEN:9WuK4Cf50Vw7Q
    // http://192.168.1.1:5000/webman/3rdparty/DownloadStation/webUI/downloadman.cgi?SynoToken=9WuK4Cf50Vw7Q
    os.Setenv("QUERY_STRING", "SynoToken="+token)
    cmd := exec.Command("/usr/syno/synoman/webman/modules/authenticate.cgi")
    cmdOut, err := cmd.Output()
    if err != nil {
        dd(err.Error()+" | "+string(cmdOut))
        // Todo return 404
        // Todo return 401
    }
    return string(cmdOut)
}

func dd(str string) { // dump and die
    // fmt.Println("Status: 200 OK\nContent-Type: text/html; charset=utf-8\n\n<!DOCTYPE html>\n<html><head><title>DNSCrypt-proxy - dump and die</title></head><body><p>")
    fmt.Println("<p>")
    fmt.Println(str)
    fmt.Println("</p></body></html>")
    os.Exit(0)
}

func main() {
    fmt.Println("Status: 200 OK\nContent-Type: text/html; charset=utf-8\n\n<!DOCTYPE html><html><head><title>DNSCrypt-proxy</title></head><body>")
    // Todo:
    // parse POST params
    // save pref changes
    // fix-up error handling with correct http responses
    // worry about csrf?
    // Done:
    // get settings from config file
    // Check authorisation
    // send csrf token
    // fix image icons


    auth()
    renderhtml()
    // user := auth()
    // dd("user: "+user)

    // if err := cgi.Serve(http.HandlerFunc(cgihandler)); err != nil {
    //     fmt.Println(err)
    // }

    fmt.Println("</body></html>")
}
