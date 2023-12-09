package main

import (
	"fmt"
	"strings"

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
	for {
		b := flipBits(reverse(a))
		dc := a + "0" + b
		if minLen == 0 {
			return dc
		}
		if len(dc) >= minLen {
			return dc[:minLen]
		}
		a = dc
	}
}

func flipBits(a string) string {
	b := strings.ReplaceAll(a, "0", "x")
	b = strings.ReplaceAll(b, "1", "0")
	b = strings.ReplaceAll(b, "x", "1")
	return b
}

func reverse(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}

func Checksum(a string) string {
	if len(a)%2 != 0 {
		return a
	}

	rv := ""
	for len(a) > 0 {
		pair := a[:2]
		a = a[2:]
		if pair == "00" || pair == "11" {
			rv += "1"
		} else {
			rv += "0"
		}
	}

	return Checksum(rv)
}

func Solve(input string, minLength int) string {
	return Checksum(DragonCurve(input, minLength))
}
