package main

import (
	"math/rand"
	"os"
	"time"

	worker "github.com/innotech/hydra-worker-round-robin/vendors/github.com/innotech/hydra-worker-lib"
)

var lastInstanceIndex map[string][]int = make(map[string][]int)

func sortSlice(instances []interface{}, fisrtElement int, appId string, iteration int) []interface{} {
	var index int = lastInstanceIndex[appId][iteration]
	computedInstances := make([]interface{}, 0)
	if index < len(instances) {
		computedInstances = append(computedInstances, instances[index:])
	}
	if index > 0 {
		computedInstances = append(computedInstances, instances[:index])
	}

	if index < len(instances)-1 {
		lastInstanceIndex[appId][iteration] = lastInstanceIndex[appId][iteration] + 1
	} else {
		lastInstanceIndex[appId][iteration] = 0
	}

	return computedInstances
}

func main() {
	// New Worker connected to Hydra Load Balancer
	roundRobinWorker := worker.NewWorker(os.Args)
	fn := func(instances []interface{}, args map[string]interface{}) []interface{} {
		var computedInstances []interface{}

		appId := args["appId"].(string)
		iteration := args["iteration"].(int)
		if _, ok := lastInstanceIndex[appId]; !ok {
			lastInstanceIndex[appId] = make([]int, 0)
		}
		if iteration >= len(lastInstanceIndex[appId]) {
			lastInstanceIndex[appId] = append(lastInstanceIndex[appId], 0)
		}
		var index int = lastInstanceIndex[appId][iteration]
		if len(instances) > index {
			computedInstances = sortSlice(instances, index+1, appId, iteration)
		} else {
			rand.Seed(time.Now().Unix())
			randomIndex := rand.Intn(len(instances))
			computedInstances = sortSlice(instances, randomIndex, appId, iteration)
		}

		return computedInstances
	}
	roundRobinWorker.Run(fn)
}
