package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
	"github.com/pjsoftware/advent-of-code/2016/lib/assembunny"
)

func main() {
  
  // Solution
  
  input := advent.InputStrings("25")
  
  start := 0
  for {
    ai := assembunny.NewInterpreter(input)
    ai.SetRegisterA(start)
    ai.TestClock(1000)
    isClock := ai.Run()
    if isClock == 1 { break }
    start++
  }
  fmt.Printf("Solution: %d\n",start)
}

// Solution code

func Solve(input string) int {
  return 0
}
