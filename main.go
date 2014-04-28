package main

import (
	"encoding/json"
	"os"

	worker "github.com/innotech/hydra-worker-pong/vendors/github.com/innotech/hydra-worker-lib"
)

var lastInstanceIndex int = 0

func sortSlice(fisrtElement int) []interface{} {
	computedInstances := make([]interface{}, 0)
	computedInstances = append(computedInstances, instances[lastInstanceIndex+1:])
	computedInstances = append(computedInstances, instances[:lastInstanceIndex+1])
	return computedInstances
}

func main() {
	if len(os.Args) < 3 {
		panic("Invalid number of arguments, you need to add at least the arguments for the server address and the service name")
	}
	serverAddr := os.Args[1]  // e.g. "tcp://localhost:5555"
	serviceName := os.Args[2] // e.g. round-robin
	verbose := len(os.Args) >= 4 && os.Args[3] == "-v"

	// New Worker connected to Hydra Load Balancer
	mapAndSortWorker := worker.NewWorker(serverAddr, serviceName, verbose)
	fn := func(instances []map[string]interface{}, args map[string]string) []interface{} {
		var computedInstances []interface{}

		if len(instances) > lastInstanceIndex {
			if len(instances) > lastInstanceIndex+1 {
				computedInstances = sortSlice(lastInstanceIndex + 1)
			}
		} else {
			rand.Seed(time.Now().Unix())
			randomIndex := rand.Intn(len(instances))
			computedInstances = sortSlice(randomIndex)
		}

		return computedInstances
	}
	mapAndSortWorker.Run(fn)
}
