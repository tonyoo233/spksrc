package main

import (
    "fmt"
    "os"
    "flag"
    "strings"
    "os/exec"
    "io/ioutil"
    "bufio"
    "errors"
    "html/template"
    "net/url"
    "regexp"
)

var dev *bool

type Page struct {
    Title string
    FileData string
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
    tempQueryEnv := os.Getenv("QUERY_STRING")
    cmd := exec.Command("/usr/syno/synoman/webman/modules/authenticate.cgi")
    cmdOut, err := cmd.Output()
    if err != nil {
        logUnauthorised(err.Error())
    }
    os.Setenv("QUERY_STRING", tempQueryEnv)

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

func loadFile(file string) (string) {
    data, err := ioutil.ReadFile(file)
    if err != nil {
        logError(err.Error())
    }
    return string(data)
}

func saveFile(file string, data string) {
    err := ioutil.WriteFile(file, []byte(data), 0644)
    if err != nil {
        logError(err.Error())
    }
    return
}

func renderHtml(configFile string) {
    var page Page
    fileData := loadFile(configFile)

    tmpl, err := template.ParseFiles("layout.html")
    if err != nil {
        logError(err.Error())
    }

    page.Title = "DNSCrypt-proxy"
    page.FileData = fileData
    fmt.Println("Status: 200 OK\nContent-Type: text/html; charset=utf-8\n")
    tmpl.Execute(os.Stdout, page)
    if err != nil {
        logError(err.Error())
    }
}


func getPost() (string) {
    // get data
    s := bufio.NewScanner(os.Stdin)
    var data string
    for s.Scan() {
        data+=s.Text()
    }
    // unescape url chars
    data, err := url.QueryUnescape(data)
    if err != nil {
        logError("bad data: "+data)
    }

    return data
}

func readPost() (string) {
    params := getPost()
    pararmSearch := "file="

    if (strings.HasPrefix(params, pararmSearch)) {
        fileData := string([]rune(params)[len(pararmSearch):])
        return fileData
    }
    return ""
}

func main() {
    // Todo:
    // fix-up error handling with correct http responses
    // worry about csrf
    // improve css

    dev = flag.Bool("dev", false, "Turns Authentication check off")
    flag.Parse()

    configFile := "/var/packages/dnscrypt-proxy/target/var/dnscrypt-proxy.toml"

    if !*dev {
        auth()
    }
    if *dev {
        configFile = "example-dnscrypt-proxy.toml"
    }


    method := os.Getenv("REQUEST_METHOD")
    if method == "POST" {
        if fileData := readPost(); fileData != "" {
            saveFile(configFile, fileData)
        }
    }

    renderHtml(configFile)
}
