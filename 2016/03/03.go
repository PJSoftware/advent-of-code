package main

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  advent.Test("sample: 5 10 25 NOT VALID", false, isValid("5  10  25"))
  advent.Test("sample: 5 20 22 VALID", true, isValid("5  20  22"))
  advent.BailOnFail()

  input := advent.InputStrings("03")
  badTri := countValidTriangles(input)
  fmt.Printf("Solution: %d\n",badTri)
}

// Solution code

func isValid(triDef string) bool {
  space := regexp.MustCompile(`\s+`)
  triDef = space.ReplaceAllString(triDef, " ")

  lenStr := strings.Split(triDef, " ")
  len1, _ := strconv.Atoi(lenStr[0])
  len2, _ := strconv.Atoi(lenStr[1])
  len3, _ := strconv.Atoi(lenStr[2])
  
  if len1 == 0 || len2 == 0 || len3 == 0 {
    return false
  }

  var sLong, sShort1, sShort2 int
  
  sLong = len1
  if (len2 > sLong) {
    sShort1 = sLong
    sLong = len2
  } else {
    sShort1 = len2
  }
  if (len3 > sLong) {
    sShort2 = sLong
    sLong = len3
  } else {
    sShort2 = len3
  }

  ssl := sShort1 + sShort2
  // fmt.Printf("Testing triangle (%s): is %d < %d?\n",triDef, sLong,ssl)
  return sLong < ssl
}

func countValidTriangles(input []string) int {
  count := 0
  for _, triDef := range(input) {
    if isValid(triDef) {
      count++
    }
  }

  return count
}