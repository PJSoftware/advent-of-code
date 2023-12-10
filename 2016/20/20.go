package main

import (
	"fmt"

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
	return 0
}
