package main

import (
	"fmt"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  testData := "abcde"
  testCode := []string{
    "swap position 4 with position 0|ebcda",
    "swap letter d with letter b|edcba",
    "reverse positions 0 through 4|abcde",
    "rotate left 1 step|bcdea",
    "move position 1 to position 4|bdeac",
    "move position 3 to position 0|abdec",
    "rotate based on position of letter b|ecabd",
    "rotate based on position of letter d|decab",
  }
  fmt.Print("Starting Tests:\n\n")
  for i, code := range testCode {
    data := strings.Split(code, "|")
    result := ExecuteCode(data[0], testData)
    advent.Test(fmt.Sprintf("Code line %d on '%s'", i+1, testData), data[1], result)
    testData = data[1] // Use what it SHOULD be for next input, not what we got
  }
  advent.Test("whole program", "decab", RunProgram(testCode, "abcde"))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  program := advent.InputStrings("21")
  fmt.Printf("Solution: %s\n", RunProgram(program, "abcdefgh"))
}

// Solution code

func RunProgram(prog []string, input string) string {
  return input
}

func ExecuteCode(code string, input string) string {
  return input
}