package main

import (
	"fmt"
	"log"
	"strconv"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")

  testData := map[string]int{
    "ADVENT": 6,
    "A(1x5)BC": 7,
    "(3x3)XYZ": 9,
    "A(2x2)BCD(2x2)EFG": 11,
    "(6x1)(1x3)A": 6,
    "X(8x2)(3x3)ABCY": 18,
    }
  for testString, testLen := range(testData) {
    testResult, _ := decompress(testString)
    advent.Test(testString, testLen, len(testResult))
    fmt.Printf("  => %s\n", testResult)
  }

  testData2 := map[string]int{
    "(3x3)XYZ": 9,
    "X(8x2)(3x3)ABCY": 20,
    "(27x12)(20x12)(13x14)(7x10)(1x12)A": 241920,
    "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN": 445,
    }
  for testString, testLen := range(testData2) {
    testResult := decompressV2(testString)
    advent.Test(testString, testLen, len(testResult))
  }
  
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputString("09")
  fmt.Printf("Initial length: %d\n",len(input))
  result, exp := decompress(input)
  fmt.Printf("First Decompression (%d exp): %d\n", exp, len(result))
  fmt.Printf("Total Decompression: %d\n", len(decompressV2(input)))
}

// Solution code

type State int
const (
  PreMarker State = iota
  Marker
  PostMarker
)

func decompressV2(text string) string {
  loopCount := 0
  var exp int
  for {
    loopCount++
    fmt.Printf("Loop %d\n", loopCount)
    text, exp = decompress(text)
    if exp == 0 {
      return text
    }
  }
}

func decompress(text string) (string, int) {
  exp := 0
  rv := ""

  state := PreMarker
  var ns string
  var seq string
  var n1 int
  var n2 int
  for _, r := range(text) {
    switch state {
    case PreMarker:
      if r == '(' {
        state = Marker
        ns = ""
        n1 = 0
        n2 = 0
      } else {
        rv += string(r)
      }

    case Marker:
      if r == 'x' {
        if n1 > 0 {
          log.Fatalf("multiple 'x' runes found in marker")
        } else {
          n1, _ = strconv.Atoi(ns)
          ns = ""
        }
      } else if r == ')' {
        n2, _ = strconv.Atoi(ns)
        state = PostMarker
        seq = ""
      } else {
        if r < '0' || r > '9' {
          log.Fatalf("non-numeric rune in marker")
        }
        ns += string(r)
      }

    case PostMarker:
      seq += string(r)
      n1--
      if n1 == 0 {
        for n2 > 0 {
          rv += seq
          n2--
        }
        state = PreMarker
        exp++
      }
    }
  }
  return rv, exp
}