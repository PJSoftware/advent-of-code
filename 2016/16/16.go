package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")

	dcGenTests := make(map[string]string)
	dcGenTests["1"] = "100"
	dcGenTests["0"] = "001"
	dcGenTests["11111"] = "11111000000"
	dcGenTests["111100001010"] = "1111000010100101011110000"
	for testInputDC, testExpDC := range dcGenTests {
		advent.Test("dragon curve", testExpDC, DragonCurve(testInputDC, 0))
	}

	checksumTests := make(map[string]string)
	checksumTests["110010110100"] = "100"
	for testInputCS, testExpCS := range checksumTests {
		advent.Test("checksum", testExpCS, Checksum(testInputCS))
	}

	testInput := "10000"
	testLength := 20
	testCS := "01100"
	testExp := "10000011110010000111"
	advent.Test("final data", testExp, DragonCurve(testInput, testLength))
	advent.Test("final sum", testCS, Solve(testInput, testLength))

	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	input := advent.InputString("16")
	length := 272
	fmt.Printf("Solution: %s\n", Solve(input, length))
}

// Solution code

func DragonCurve(a string, minLen int) string {
	return a
}

func Checksum(a string) string {
	return "x"
}

func Solve(input string, minLength int) string {
	return Checksum(DragonCurve(input, minLength))
}
