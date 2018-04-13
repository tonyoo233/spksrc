package main

import (
    "fmt"
    "os"
    "os/exec"
    "errors"
    "html/template"
    "regexp"
    "github.com/BurntSushi/toml"
)

// ref: https://github.com/jedisct1/dnscrypt-proxy/blob/master/dnscrypt-proxy/config.go
type Config struct {
    Title string
    ListenAddresses []string `toml:"listen_addresses"`
    ServerNames []string `toml:"server_names"`
    SourceIPv6 bool `toml:"ipv6_servers"`
}

func renderhtml() {
    var conf Config
    // if _, err := toml.DecodeFile("example-dnscrypt-proxy.toml", &conf); err != nil { // for development
    if _, err := toml.DecodeFile("/var/packages/dnscrypt-proxy/target/var/dnscrypt-proxy.toml", &conf); err != nil {
        logError(err.Error())
    }

    tmpl, err := template.ParseFiles("layout.html")
    if err != nil {
        logError(err.Error())
    }

    conf.Title = "DNSCrypt-proxy"
    fmt.Println("Status: 200 OK\nContent-Type: text/html; charset=utf-8\n\n")
    tmpl.Execute(os.Stdout, conf)
    if err != nil {
        logError(err.Error())
    }
}

func token() (string, error) {
    cmd := exec.Command("/usr/syno/synoman/webman/login.cgi")
    cmdOut, err := cmd.Output()
    if err != nil && err.Error() != "exit status 255" { // in the Synology world, error code 255 apparently means success!
        return string(cmdOut), err
    }

    // Content-Type: text/html [..] { "SynoToken" : "GqHdJil0ZmlhE", "result" : "success", "success" : true }
    r, err := regexp.Compile("SynoToken\" *: *\"([^\"]+)\"")
    if err != nil {
        return string(cmdOut), err
    }
    token := r.FindSubmatch(cmdOut)
    if len(token) < 1 {
        return string(cmdOut), errors.New("Sorry, you need to login first!")
    }
    return string(token[1]), nil
}

func auth() (string) {
    token, err := token()
    if err != nil {
        logUnauthorised(err.Error())
    }

    // X-SYNO-TOKEN:9WuK4Cf50Vw7Q
    // http://192.168.1.1:5000/webman/3rdparty/DownloadStation/webUI/downloadman.cgi?SynoToken=9WuK4Cf50Vw7Q
    os.Setenv("QUERY_STRING", "SynoToken="+token)
    cmd := exec.Command("/usr/syno/synoman/webman/modules/authenticate.cgi")
    cmdOut, err := cmd.Output()
    if err != nil {
        logUnauthorised(err.Error())
    }
    return string(cmdOut)
}

func logError(str string) { // dump and die
    fmt.Println("Status: 500 Internal server error\nContent-Type: text/html; charset=utf-8\n\n")
    fmt.Println(str)
    os.Exit(0)
}
func logUnauthorised(str string) { // dump and die
    fmt.Println("Status: 401 Unauthorized\nContent-Type: text/html; charset=utf-8\n\n")
    fmt.Println(str)
    os.Exit(0)
}

func main() {
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

    // user := auth()
    // dd("user: "+user)
    auth()
    renderhtml()
}
