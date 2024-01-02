package main

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type triangle struct {
  side1 int
  side2 int
  side3 int

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
  
  testTriangles = parseTrianglesByColumn(testData)
  testTri = testTriangles[0]
  advent.Test("read by col: tri 1",103,testTri.sideH)

  advent.BailOnFail()

  // Solution

  input := advent.InputStrings("03")
  triangles := parseTriangles(input)
  goodTri := countValidTriangles(triangles)
  fmt.Printf("Solution by row: %d\n",goodTri)
  
  triangles = parseTrianglesByColumn(input)
  goodTri = countValidTriangles(triangles)
  fmt.Printf("Solution by col: %d\n",goodTri)
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

func parseTrianglesByColumn(input []string) []triangle {
  triByRow := parseTriangles(input)
  var rv []triangle

  i := 0
  for i < len(triByRow) {
    tri1 := triByRow[i+0]
    tri2 := triByRow[i+1]
    tri3 := triByRow[i+2]
    i += 3

    rv = append(rv, *newTriangle(tri1.side1, tri2.side1, tri3.side1))
    rv = append(rv, *newTriangle(tri1.side2, tri2.side2, tri3.side2))
    rv = append(rv, *newTriangle(tri1.side3, tri2.side3, tri3.side3))
  }

  return rv
}

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

func newTriangle(s1, s2, s3 int) *triangle {
  tri := &triangle{}
  tri.side1 = s1
  tri.side2 = s2
  tri.side3 = s3
  tri.sortSides()
  return tri
}

func newTriangleByString(triDef string) *triangle {
  tri := &triangle{}

  space := regexp.MustCompile(`\s+`)
  triDef = space.ReplaceAllString(triDef, " ")

  lenStr := strings.Split(triDef, " ")
  tri.side1, _ = strconv.Atoi(lenStr[0])
  tri.side2, _ = strconv.Atoi(lenStr[1])
  tri.side3, _ = strconv.Atoi(lenStr[2])
  
  if tri.side1 == 0 || tri.side2 == 0 || tri.side3 == 0 {
    return nil
  }
  
  tri.sortSides()
  return tri
}

func (tri *triangle) sortSides() {
  tri.sideH = tri.side1
  if (tri.side2 > tri.sideH) {
    tri.sideA = tri.sideH
    tri.sideH = tri.side2
  } else {
    tri.sideA = tri.side2
  }
  if (tri.side3 > tri.sideH) {
    tri.sideB = tri.sideH
    tri.sideH = tri.side3
  } else {
    tri.sideB = tri.side3
  }
}