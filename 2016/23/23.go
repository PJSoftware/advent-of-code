package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
	"github.com/pjsoftware/advent-of-code/2016/lib/assembunny"
)

func main() {
  // Tests

  testProg := []string{
    "cpy 2 a",
    "tgl a",
    "tgl a",
    "tgl a",
    "cpy 1 a",
    "dec a",
    "dec a",
  }
  fmt.Print("Starting Tests:\n\n")
  testAI := assembunny.NewInterpreter(testProg)
  testAI.Run()
  advent.Test("test code", 3, testAI.RegisterA())
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputStrings("23")
  ai1 := assembunny.NewInterpreter(input)
  ai1.Run()
  fmt.Printf("Solution: %d\n",ai1.RegisterA())
}
