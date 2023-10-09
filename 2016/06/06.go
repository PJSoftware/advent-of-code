package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  testData := []string {
    "eedadn",
    "drvtee",
    "eandsr",
    "raavrd",
    "atevrs",
    "tsrnev",
    "sdttsa",
    "rasrtv",
    "nssdts",
    "ntnada",
    "svetve",
    "tesnvt",
    "vntsnd",
    "vrdear",
    "dvrsen",
    "enarar",
  }

  fmt.Print("Starting Tests:\n\n")
  advent.Test("sample", "easter", Solve(testData))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputStrings("06")
  fmt.Printf("Solution: %s\n",Solve(input))
}

// Solution code

func Solve(input []string) string {
  input = transpose(input)
  message := ""

  for _, text := range(input) {
    message += mostFrequent(text)
  }

  return message
}

func transpose(input []string) []string {
  var output []string

  for x, line := range(input) {
    for i, ch := range(line) {
      if x == 0 {
        output = append(output, "")
      }
      output[i] += string(ch)
    }
  }
  return output
}

func mostFrequent(text string) string {
  rf := countRuneFrequency(text)
  hf := 0
  var mf rune
  for r, f := range(rf) {
    if f > hf {
      hf = f
      mf = r
    }
  }
  return string(mf)
}

func countRuneFrequency(text string) map[rune]int {
  freq := map[rune]int{}
  for r := 'a'; r <= 'z'; r++ {
    freq[r] = 0
  }

  for _, ch := range(text) {
    if ch != '-' {
      freq[ch]++
    }
  }
  return freq
}
