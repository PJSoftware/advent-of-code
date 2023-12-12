package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
	"github.com/pjsoftware/advent-of-code/2016/lib/assembunny"
)

// This code was refactored on day 23, so we could reuse the assembunny interpreter

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")

  testCode := []string{
    "cpy 41 a",
    "inc a",
    "inc a",
    "dec a",
    "jnz a 2",
    "dec a",
  }
  advent.Test("testCode", 42, assembunny.RunAndReturnA(testCode))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputStrings("12")
  fmt.Print("Running assembunny code:\n")
  fmt.Printf("Solution Part 1: %d\n",assembunny.RunAndReturnA(input))

  input2 := []string{}
  input2 = append(input2, "cpy 1 c")
  input2 = append(input2, input...)
  fmt.Printf("Solution Part 2: %d\n",assembunny.RunAndReturnA(input2))
}
