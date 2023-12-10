package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")

	testData := map[string]string{
		"ihgpwlah": "DDRRRD",
		"kglvqrro": "DDUDRLRRUDRD",
		"ulqzkmiv": "DRURDRUDDLLDLUURRDULRLDUUDDDRR",
	}
	for testPass, testAnswer := range testData {
		advent.Test("passcode calculation", testAnswer, Solve(testPass))
	}
	advent.BailOnFail()

	fmt.Print("All tests passed!\n\n")

	// Solution

	passCode := advent.InputString("17")
	fmt.Printf("Solution: %s\n", Solve(passCode))
}

// Solution code

func Solve(passcode string) string {
	return ""
}
