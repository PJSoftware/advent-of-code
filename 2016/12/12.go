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

  testAI := assembunny.NewInterpreter(testCode)
  testAI.Run()
  advent.Test("testCode", 42, testAI.RegisterA())
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputStrings("12")
  fmt.Print("Running assembunny code:\n")
  
  ai1 := assembunny.NewInterpreter(input)
  ai1.Run()
  fmt.Printf("Solution Part 1: %d\n",ai1.RegisterA())

  ai2 := assembunny.NewInterpreter(input)
  ai2.SetRegisterC(1)
  ai2.Run()
  fmt.Printf("Solution Part 2: %d\n",ai2.RegisterA())
}
