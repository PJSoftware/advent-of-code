package main

import (
	"fmt"
	"log"
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
	advent.Test("test network", 3, LowestAllowableIP(testBlacklist))
	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	blacklist := advent.InputStrings("20")
	fmt.Printf("Lowest Allowable IP: %d\n", LowestAllowableIP(blacklist))
}

// Solution code

func LowestAllowableIP(input []string) int {
	blackList := make(map[int]int)
	for _, row := range input {
		low, high := parse(row)
		blackList[low] = high
	}

	test := 0
	for {
		if next, ok := blackList[test]; ok {
			test = next + 1
		} else {
			return test
		}
	}
}

func parse(row string) (int, int) {
	val := strings.Split(row, "-")
	if len(val) != 2 {
		log.Fatalf("Row '%s' does not mach expected nnn-nnn pattern", row)
	}

	n1, _ := strconv.ParseInt(val[0], 10, 64)
	n2, _ := strconv.ParseInt(val[1], 10, 64)
	return int(n1), int(n2)
}
