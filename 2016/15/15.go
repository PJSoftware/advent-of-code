package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type Disc struct {
	Number   int
	PosCount int
	CurrPos  int
}

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")

	testInput := []string{
		"Disc #1 has 5 positions; at time=0, it is at position 4.",
		"Disc #2 has 2 positions; at time=0, it is at position 1.",
	}
	testDiscs := Parse(testInput)
	advent.Test("Test", 5, Solve(testDiscs))
	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	input := advent.InputStrings("15")
	discs := Parse(input)
	fmt.Printf("Solution: %d\n", Solve(discs))
}

// Solution code

func Parse(input []string) []Disc {
	discs := []Disc{}
	return discs
}

func Solve(input []Disc) int {
	return 0
}
