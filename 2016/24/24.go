package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")

  testMaze := []string{
    "###########",
    "#0.1.....2#",
    "#.#######.#",
    "#4.......3#",
    "###########",
  }
  advent.Test("testMaze", 14, Solve(testMaze))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  maze := advent.InputStrings("24")
  fmt.Printf("Solution: %d\n",Solve(maze))
}

// Solution code

func Solve(maze []string) int {
  return 0
}
