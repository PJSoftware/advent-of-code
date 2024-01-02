package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")
  advent.Test("sample1", 1, Solve("input1"))
  advent.Test("sample2", 2, Solve("input2"))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputString("NN")
  fmt.Printf("Solution: %d\n",Solve(input))
}

// Solution code

func Solve(input string) int {
  return 0
}
