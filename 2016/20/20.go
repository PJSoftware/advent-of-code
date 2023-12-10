package main

import (
	"fmt"
	"log"
	"math"
	"slices"
	"strconv"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
	// Tests

	testBlacklist := []string{
		"5-8",
		"0-2",
		"4-7",
	}

	fmt.Print("Starting Tests:\n\n")
	advent.Test("test network", uint32(3), LowestAllowableIP(testBlacklist))
	advent.Test("test ip-count", 2, CountAvailable(testBlacklist, 0, 9))
	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	blacklist := advent.InputStrings("20")
	fmt.Printf("Lowest Allowable IP: %d\n", LowestAllowableIP(blacklist))
	fmt.Printf("# Available IPs: %d\n", CountAvailable(blacklist, 0, math.MaxUint32))

}

// Solution code

func LowestAllowableIP(input []string) uint32 {
	blackList := make(map[uint32]uint32)
	for _, row := range input {
		low, high := parse(row)
		blackList[low] = high
	}

	keys := make([]uint32, 0, len(blackList))
	for k := range blackList {
		keys = append(keys, k)
	}
	slices.Sort(keys)

	testAvail := uint32(0)
	for _, k := range keys {
		// fmt.Printf("Examining %d in range %d-%d\n", testAvail, k, blackList[k])
		if testAvail < k {
			return testAvail
		}
		if blackList[k] > testAvail {
			testAvail = blackList[k] + 1
		}
	}
	return 0
}

func CountAvailable(input []string, min, max uint32) int {
	blackList := make(map[uint32]uint32)
	for _, row := range input {
		low, high := parse(row)
		blackList[low] = high
	}

	keys := make([]uint32, 0, len(blackList))
	for k := range blackList {
		keys = append(keys, k)
	}
	slices.Sort(keys)

	return 2
}

func parse(row string) (uint32, uint32) {
	val := strings.Split(row, "-")
	if len(val) != 2 {
		log.Fatalf("Row '%s' does not mach expected nnn-nnn pattern", row)
	}

	n1, _ := strconv.ParseInt(val[0], 10, 64)
	n2, _ := strconv.ParseInt(val[1], 10, 64)
	return uint32(n1), uint32(n2)
}
