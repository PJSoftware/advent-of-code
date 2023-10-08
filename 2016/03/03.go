package main

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type triangle struct {
  sideA int
  sideB int
  sideH int
}

func main() {
  // Tests

  advent.Test("sample: 5 10 25 NOT VALID", false, isValid(newTriangleByString("5  10  25")))
  advent.Test("sample: 5 20 22 VALID", true, isValid(newTriangleByString("5  20  22")))

  testData := []string{
    "101  301  501",
    "102  302  502",
    "103  303  503",
    "201  401  601",
    "202  402  602",
    "203  403  603",
  }
  
  testTriangles := parseTriangles(testData)
  testTri := testTriangles[0]
  advent.Test("read by row: tri 1",501,testTri.sideH)
  
  // testTriangles = parseTrianglesByColumn(testData)
  // testTri = testTriangles[0]
  // advent.Test("read by row: tri 1",103,testTri.sideH)

  advent.BailOnFail()

  // Solution

  input := advent.InputStrings("03")
  triangles := parseTriangles(input)
  badTri := countValidTriangles(triangles)
  fmt.Printf("Solution: %d\n",badTri)
}

// Solution code

func parseTriangles(input []string) []triangle {
  var rv []triangle

  for _, triDef := range(input) {
    tri := newTriangleByString(triDef)
    if tri != nil {
      rv = append(rv, *tri)
    }
  }

  return rv
}

// func parseTrianglesByColumn(input []string) []triangle {
//   triByRow := parseTriangles(input)
//   return triByRow
// }

func isValid(tri *triangle) bool {
  return tri.sideH < (tri.sideA + tri.sideB)
}

func countValidTriangles(input []triangle) int {
  count := 0
  for _, tri := range(input) {
    if isValid(&tri) {
      count++
    }
  }

  return count
}

func newTriangleByString(triDef string) *triangle {
  tri := &triangle{}

  space := regexp.MustCompile(`\s+`)
  triDef = space.ReplaceAllString(triDef, " ")

  lenStr := strings.Split(triDef, " ")
  len1, _ := strconv.Atoi(lenStr[0])
  len2, _ := strconv.Atoi(lenStr[1])
  len3, _ := strconv.Atoi(lenStr[2])
  
  if len1 == 0 || len2 == 0 || len3 == 0 {
    return nil
  }
  
  tri.sideH = len1
  if (len2 > tri.sideH) {
    tri.sideA = tri.sideH
    tri.sideH = len2
  } else {
    tri.sideA = len2
  }
  if (len3 > tri.sideH) {
    tri.sideB = tri.sideH
    tri.sideH = len3
  } else {
    tri.sideB = len3
  }

  return tri
}