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
  }
  
  testData2 := map[string]int{
    "(3x3)XYZ": 9,
    "X(8x2)(3x3)ABCY": 20,
    "(27x12)(20x12)(13x14)(7x10)(1x12)A": 241920,
    "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN": 445,
  }
  for testString, testLen := range(testData2) {
    // fmt.Printf("SPLIT: %s => (%v)\n", testString, splitCompressed(testString))
    advent.Test(fmt.Sprintf("DND: %s",testString), testLen, decompLength(testString))
  }
  
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputString("09")
  fmt.Printf("Initial length: %d\n",len(input))
  result, exp := decompress(input)
  fmt.Printf("First Decompression (%d exp): %d\n", exp, len(result))
  fmt.Printf("Total Decomp Length: %d\n", decompLength(input))
}

// Solution code

type State int
const (
  PreMarker State = iota
  Marker
  PostMarker
)

func decompLength(text string) int {
  items := splitCompressed(text)
  if len(items) == 1 {
    return chunkLength(items[0])
  }

  tl := 0
  for _, item := range(items) {
    tl += decompLength(item)
  }
  return tl  
}

func chunkLength(chunk string) int {
  isCompRE := regexp.MustCompile(`^\((\d+)x(\d+)\)(.+)$`)
  if isCompRE.MatchString(chunk) {
    match := isCompRE.FindStringSubmatch(chunk)
    n1, _ := strconv.Atoi(match[1])
    n2, _ := strconv.Atoi(match[2])
    str := match[3]
    if len(str) != n1 {
      log.Fatalf("Length of substring is not %d as expected", n1)
    }
    return n2 * decompLength(str)
  }
  return len(chunk)
}

func splitCompressed(text string) []string {
  rv := []string{}
  str := ""

  state := PreMarker
  var ns string
  var n1 int
  for _, r := range(text) {
    switch state {
    case PreMarker:
      if r == '(' {
        if str != "" {
          rv = append(rv, str)
        }
        str = "("
        state = Marker
        ns = ""
        n1 = 0
      } else {
        str += string(r)
      }

    case Marker:
      if r == 'x' {
        str += string(r)
        if n1 > 0 {
          log.Fatalf("multiple 'x' runes found in marker")
        } else {
          n1, _ = strconv.Atoi(ns)
          ns = ""
        }
      } else if r == ')' {
        str += string(r)
        state = PostMarker
      } else {
        if r < '0' || r > '9' {
          log.Fatalf("non-numeric rune in marker")
        }
        str += string(r)
        ns += string(r)
      }

    case PostMarker:
      str += string(r)
      n1--
      if n1 == 0 {
        rv = append(rv, str)
        str = ""
        state = PreMarker
      }
    }
  }
  if str != "" {
    rv = append(rv, str)
  }
  return rv
}

// func decompressV2(text string) string {
//   loopCount := 0
//   var exp int
//   for {
//     loopCount++
//     fmt.Printf("Loop %d\n", loopCount)
//     text, exp = decompress(text)
//     if exp == 0 {
//       return text
//     }
//   }
// }

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