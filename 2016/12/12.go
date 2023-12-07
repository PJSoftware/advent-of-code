package main

import (
	"fmt"
	"log"
	"regexp"
	"strconv"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

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
  advent.Test("testCode", 42, RunAndReturnA(testCode))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputStrings("12")
  fmt.Print("Running assembunny code:\n")
  fmt.Printf("Solution: %d\n",RunAndReturnA(input))
}

// Solution code

type Register map[string]int

func RunAndReturnA(code []string) int {
  reg := make(Register)
  reg["a"] = 0
  reg["b"] = 0
  reg["c"] = 0
  reg["d"] = 0

  index := 0
  re := regexp.MustCompile("(cpy|inc|dec|jnz) ([0-9a-z]+) ?([0-9a-z-]+)?")
  for index < len(code) {
    line := code[index]
    instruction := re.FindStringSubmatch(line)
    switch instruction[1] {
    case "cpy":
      regX := instruction[3]
      val := 0
      if isNumeric(instruction[2]) {
        x, _ := strconv.ParseInt(instruction[2], 10, 32)
        val = int(x)
      } else {
        val = reg[instruction[2]]
      }
      reg[regX] = val
      index++

    case "inc":
      reg[instruction[2]]++
      index++
      
    case "dec":
      reg[instruction[2]]--
      index++

    case "jnz":
      if reg[instruction[2]] != 0 {
        y, _ := strconv.ParseInt(instruction[3], 10, 32)
        index += int(y)
      } else {
        index++
      }

    default:
      log.Fatalf("Unknown instruction '%s' at line %d", line, index)
      
    }
  }

  return reg["a"]
}

func isNumeric(s string) bool {
  _, err := strconv.ParseInt(s, 10, 32)
  return err == nil
}
