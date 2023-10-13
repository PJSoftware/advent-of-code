package main

import (
	"fmt"
	"log"
	"strconv"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  testData := map[string]int{
    "ADVENT": 6,
    "A(1x5)BC": 7,
    "(3x3)XYZ": 9,
    "A(2x2)BCD(2x2)EFG": 11,
    "(6x1)(1x3)A": 6,
    "X(8x2)(3x3)ABCY": 18,
    }

  fmt.Print("Starting Tests:\n\n")
  for testString, testLen := range(testData) {
    testResult, _ := decompress(testString)
    advent.Test(testString, testLen, len(testResult))
    fmt.Printf("  => %s\n", testResult)
  }
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputString("09")
  fmt.Printf("Initial length: %d\n",len(input))
  result, exp := decompress(input)
  fmt.Printf("First Decompression (%d exp): %d\n", exp, len(result))
}

// Solution code

type State int
const (
  PreMarker State = iota
  Marker
  PostMarker
)

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
      }
    }
  }
  return rv, exp
}