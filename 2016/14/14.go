package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")

  testSalt := "abc"
  advent.Test("64th OTP key index", 22728, Solve(testSalt))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  salt := advent.InputString("NN")
  fmt.Printf("Index of 64th OTP key: %d\n",Solve(salt))
}

// Solution code

func Solve(salt string) int {
  return 0
}
