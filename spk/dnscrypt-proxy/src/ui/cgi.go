package main

import (
    "errors"
    "flag"
    "fmt"
    "html/template"
    "io/ioutil"
    "net/url"
    "os"
    "os/exec"
    "regexp"
    "strings"
    "bytes"
)

var dev *bool
var rootDir string
var configFile string

type Page struct {
    Title    string
    FileData string
    ErrorMessage string
    SuccessMessage string
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

func auth() string {
    token, err := token()
    if err != nil {
        logUnauthorised(err.Error())
    }

    // X-SYNO-TOKEN:9WuK4Cf50Vw7Q
    // http://192.168.1.1:5000/webman/3rdparty/DownloadStation/webUI/downloadman.cgi?SynoToken=9WuK4Cf50Vw7Q
    os.Setenv("QUERY_STRING", "SynoToken="+token)
    tempQueryEnv := os.Getenv("QUERY_STRING")
    cmd := exec.Command("/usr/syno/synoman/webman/modules/authenticate.cgi")
    cmdOut, err := cmd.Output()
    if err != nil {
        logUnauthorised(err.Error())
    }
    os.Setenv("QUERY_STRING", tempQueryEnv)

    return string(cmdOut)
}

func logError(str ...string) { // dump and die
    fmt.Println("Status: 500 Internal server error\nContent-Type: text/html; charset=utf-8\n")
    fmt.Println(strings.Join(str, ", "))
    os.Exit(0)
}

func logUnauthorised(str ...string) { // dump and die
    fmt.Println("Status: 401 Unauthorized\nContent-Type: text/html; charset=utf-8\n")
    fmt.Println(strings.Join(str, ", "))
    os.Exit(0)
}

func loadFile(file string) string {
    data, err := ioutil.ReadFile(file)
    if err != nil {
        logError(err.Error())
    }
    return string(data)
}

func saveFile(file string, data string) {
    err := ioutil.WriteFile(file+".tmp", []byte(data), 0644)
    if err != nil {
        logError(err.Error())
    }

    checkConfFile()

    err = os.Rename(file+".tmp", file)
    if err != nil {
        logError(err.Error())
    }

    return
}

func checkConfFile() {
    var errbuf bytes.Buffer
    cmd := exec.Command(rootDir+"/bin/dnscrypt-proxy", "-check", "-config", configFile+".tmp")
    cmd.Stderr = &errbuf

    out, err := cmd.Output()
    if err != nil {
        //logError(err.Error(), string(out), errbuf.String())
        renderHtml(configFile, "", string(out)+errbuf.String())
        os.Exit(0)
    }
}

func renderHtml(configFile string, successMessage string, errorMessage string) {
    var page Page
    fileData := loadFile(configFile)

    tmpl, err := template.ParseFiles("layout.html")
    if err != nil {
        logError(err.Error())
    }

    page.Title = "DNSCrypt-proxy"
    page.FileData = fileData
    page.ErrorMessage = errorMessage
    page.SuccessMessage = successMessage
    fmt.Println("Status: 200 OK\nContent-Type: text/html; charset=utf-8\n")
    err = tmpl.Execute(os.Stdout, page)
    if err != nil {
        logError(err.Error())
    }
    os.Exit(0)
}

func readPost() url.Values { // todo: stop on a max size (10mb?)
    // fixme: check/generate csrf token
    bytes, err := ioutil.ReadAll(os.Stdin)
    if err != nil {
        logError(err.Error())
    }

    q, err := url.ParseQuery(string(bytes))
    if err != nil {
        logError(err.Error())
    }
    return q
}

func main() {
    // Todo:
    // fix-up error handling with correct http responses
    // worry about csrf
    // improve css

    dev = flag.Bool("dev", false, "Turns Authentication checks off")
    flag.Parse()

    rootDir = "test"
    if !*dev {
        auth()
        rootDir = "/var/packages/dnscrypt-proxy/target"
    }

    configFile = rootDir + "/var/dnscrypt-proxy.toml"
    method := os.Getenv("REQUEST_METHOD")
    if method == "POST" || method == "PUT" || method == "PATCH" {
        if fileData := readPost().Get("file"); fileData != "" {
            saveFile(configFile, fileData)
            renderHtml(configFile, "Saved Successfully!", "")
            // fmt.Println("Status: 200 OK\nContent-Type: text/plain;\n")
            // return
        }
    }

    renderHtml(configFile, "", "")
}
