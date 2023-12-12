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
  numEggs := 7
  colEggs := 5

  ai1 := assembunny.NewInterpreter(input)
  ai1.SetRegisterA(numEggs)
  ai1.Run()
  fmt.Printf("Solution: %d\n",ai1.RegisterA())

  ai2 := assembunny.NewInterpreter(input)
  ai2.SetRegisterA(numEggs+colEggs)
  ai2.Debug()
  ai2.Run()
  fmt.Printf("Solution: %d\n",ai2.RegisterA())
}
