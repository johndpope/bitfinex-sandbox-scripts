package main

import (
        "io"
        "net/http"
        "fmt"
        "log"
        "github.com/samalba/dockerclient"
        "strings"
)

func hello(w http.ResponseWriter, r *http.Request) {
    searchName := r.URL.Query().Get("name")
    docker, _ := dockerclient.NewDockerClient("unix:///var/run/docker.sock", nil)

    // Get only running containers
    containers, err := docker.ListContainers(false, false, "")
    if err != nil {
        log.Fatal(err)
    }
    for _, c := range containers {
        // log.Println(c.Names, c.Ports)
        for _, name := range c.Names {
                if (strings.Contains(name, searchName)) {
                        io.WriteString(w, fmt.Sprintf("<a href=\"http://sandbox.bitfinex.to:%v\">%v</a><br>", c.Ports[0].PublicPort, name))
                }
        }
    }
}

func main() {
        http.HandleFunc("/", hello)
        http.ListenAndServe(":8000", nil)
}

