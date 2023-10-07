package main

import (
	"fmt"
	"log"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

var TestsFailed int

func main() {
  TestSampleData("sample1","input1",1)
  TestSampleData("sample2","input2",2)
  BailOnFail()

  input := advent.InputString("NN")
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
