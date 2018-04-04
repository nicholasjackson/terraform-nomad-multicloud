package main

import (
	"flag"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"strings"
	"time"

	"github.com/DataDog/datadog-go/statsd"
)

var statsdAddr = flag.String("statsd_addr", "localhost:8125", "")
var version = flag.String("version", "v1", "")
var port = flag.Int("port", 8080, "")
var allocID = flag.String("alloc_id", "localhost:8080", "")
var privateKey = flag.String("tls_key", "", "")
var cert = flag.String("tls_cert", "", "")

var stats *statsd.Client

func main() {
	rand.Seed(time.Now().Unix())

	flag.Parse()
	log.Printf("Starting example server, alloc_id: %s, version:%s, using statsd:%s", *allocID, *version, *statsdAddr)

	var err error
	stats, err = statsd.New(*statsdAddr)
	if err != nil {
		log.Fatal("Unable to start server", err)
	}

	stats.Namespace = "testapp."
	stats.Tags = append(stats.Tags, "version:"+*version)
	stats.Tags = append(stats.Tags, "allocid:"+strings.Split(*allocID, "-")[0])

	stats.Incr("server.started", nil, 1)

	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/", mainHandler)

	if *privateKey != "" && *cert != "" {
		log.Fatal(http.ListenAndServeTLS(
			fmt.Sprintf(":%d", *port),
			*cert,
			*privateKey,
			nil,
		))
	}

	// otherwise no https
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", *port), nil))
}

func mainHandler(rw http.ResponseWriter, r *http.Request) {
	log.Println("Handle main endpoint")

	defer func(st time.Time) {
		err := stats.Timing("main.called", time.Now().Sub(st), nil, 1)
		if err != nil {
			log.Println("Error: unable to send metrics", err)
		}
	}(time.Now())

	// random delay
	rt := rand.Intn(20-10) + 10
	time.Sleep(time.Duration(rt) * time.Microsecond)
}

func healthHandler(rw http.ResponseWriter, r *http.Request) {
	log.Println("Handle health check endpoint")

	defer func(st time.Time) {
		err := stats.Timing("health.called", time.Now().Sub(st), nil, 1)
		if err != nil {
			log.Println("Error: unable to send metrics", err)
		}
	}(time.Now())
}
