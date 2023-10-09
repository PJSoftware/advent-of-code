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
  advent.Test("repetition", "easter", SolveRC(testData))
  advent.Test("modified", "advent", SolveMRC(testData))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputStrings("06")
  fmt.Printf("Solution (rep): %s\n",SolveRC(input))
  fmt.Printf("Solution (mod): %s\n",SolveMRC(input))
}

// Solution code

func SolveRC(input []string) string {
  input = transpose(input)
  message := ""

  for _, text := range(input) {
    message += mostFrequent(text)
  }

  return message
}

func SolveMRC(input []string) string {
  input = transpose(input)
  message := ""

  for _, text := range(input) {
    message += leastFrequent(text)
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

func leastFrequent(text string) string {
  rf := countRuneFrequency(text)
  lf := len(text)+1
  var mf rune
  for r, f := range(rf) {
    if f == 0 {
      continue
    }

    if f < lf {
      lf = f
      mf = r
    }
  }
  // fmt.Printf("Least frequent in '%s' => %c\n",text,mf)
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
