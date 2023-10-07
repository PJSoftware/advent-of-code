package main

import (
	"fmt"
	"log"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

var TestsFailed int

func main() {
  TestSampleData("sample1","R2, L3",5)
  TestSampleData("sample2","R2, R2, R2",2)
  TestSampleData("sample3","R5, L5, R5, R3",12)
  BailOnFail()

  input := advent.ReadString("01-input.txt")
  fmt.Printf("Solution: %d\n",Solve(input))
}

// Testing sample data

func TestSampleData(testName string, input string, exp int) {
  got := Solve(input)
  if got == exp {
    fmt.Printf("OK -- %s passed\n", testName);
  } else {
    fmt.Printf("FAIL -- %s (%s) failed;\n  - exp '%d';\n  - got '%d'\n", testName, input, exp, got)
    TestsFailed++
  }
}

func BailOnFail() {
  if TestsFailed > 0 {
    log.Fatalf("Sample Data Tests: %d failed", TestsFailed)
  }
  fmt.Println()
}

// Solution code

func Solve(input string) int {
  return 0
}
