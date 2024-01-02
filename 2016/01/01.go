package main

import (
	"fmt"
	"log"
	"math"
	"strconv"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

var TestsFailed int
var Visited []string

func main() {
  TestSampleData("sample1","R2, L3",5)
  TestSampleData("sample2","R2, R2, R2",2)
  TestSampleData("sample3","R5, L5, R5, R3",12)

  TestDoubleVisit("doubleVisit","R8, R4, R4, R8",4)

  BailOnFail()

  input := advent.InputString("01")
  fmt.Printf("Solution 1: %d\n",Solve(input))
  fmt.Printf("Solution 2: %d\n",FirstRevisitDistance())
}

// Testing sample data

func TestSampleData(testName string, input string, exp int) {
  got := Solve(input)
  if got == exp {
    fmt.Printf("OK -- %s passed\n", testName);
  } else {
    fmt.Printf("FAIL -- %s (%s) failed;\n  - exp '%d';\n  - got '%d'\n", testName, input, exp, got)
    TestsFailed++
  }
}

func TestDoubleVisit(testName string, input string, exp int) {
  _ = Solve(input)
  got := FirstRevisitDistance()
  if got == exp {
    fmt.Printf("OK -- %s passed\n", testName);
  } else {
    fmt.Printf("FAIL -- %s (%s) failed;\n  - exp '%d';\n  - got '%d'\n", testName, input, exp, got)
    TestsFailed++
  }
}

func BailOnFail() {
  if TestsFailed > 0 {
    log.Fatalf("Sample Data Tests: %d failed", TestsFailed)
  }
  fmt.Println()
}

// Solution code

func Solve(input string) int {
  instructions := strings.Split(input, ", ")
  cardinal := []string{"N", "E", "S", "W"}
  facing := 0
  x := 0
  y := 0

  Visited = nil
  Visited = append(Visited, fmt.Sprintf("%d,%d",x,y))

  for _, instruction := range(instructions) {
    turn := string(instruction[0])
    dist, err := strconv.Atoi(string(instruction[1:]))
    if err != nil {
      log.Fatalf("Instruction '%s' not in expected format", instruction)
    }

    facing = Turn(turn, facing)
    x, y = Move(x, y, cardinal[facing], dist)
  }

  return int(math.Abs(float64(x)) + math.Abs(float64(y)))
}

func Turn(turnDir string, facing int) int {
  switch turnDir {
  case "L":
    facing--
    if facing == -1 {
      facing = 3
    }
  case "R":
    facing++
    if facing == 4 {
      facing = 0
    }
  }
  return facing
}

func Move(x, y int, dir string, dist int) (int,int) {
  for i := 1; i <= dist; i++ {
    switch dir {
    case "N": y++
    case "W": x--
    case "S": y--
    case "E": x++
    }
    Visited = append(Visited, fmt.Sprintf("%d,%d",x,y))
  }
  return x, y
}

func FirstRevisitDistance() int {
  trackVisit := make(map[string]bool)
  for _, loc := range(Visited) {
    if _, ok := trackVisit[loc]; ok {
      fmt.Printf("Location '%s' has already been visited!\n", loc)
      return DistTo(loc)
    }
    trackVisit[loc] = true
  }

  return 0
}

func DistTo(loc string) int {
  coord := strings.Split(loc,",")
  x, _ := strconv.Atoi(coord[0])
  y, _ := strconv.Atoi(coord[1])
  return int(math.Abs(float64(x)) + math.Abs(float64(y)))
}