package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  advent.Test("sample1", 1, Solve("input1"))
  advent.Test("sample2", 2, Solve("input2"))
  advent.BailOnFail()

  input := advent.InputString("NN")
  fmt.Printf("Solution: %d\n",Solve(input))
}

// Solution code

func Solve(input string) int {
  return 0
}
