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
  advent.Test("test code", 3, assembunny.RunAndReturnA(testProg))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputStrings("23")
  fmt.Printf("Solution: %d\n",assembunny.RunAndReturnA(input))
}
