package main

import (
	"fmt"
	"log"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

var TestsFailed int

func main() {
  testData := []string{
    "ULL",
    "RRDDD",
    "LURDL",
    "UUUUD",
  }
  testExp := "1985"
  testGot := Decode(testData)
  TestSampleData("testCode",testExp,testGot)
  BailOnFail()

  input := advent.InputStrings("02")
  fmt.Printf("Solution: %s\n",Decode(input))
}

// Testing sample data

func TestSampleData(testName string, exp string, got string) {
  if got == exp {
    fmt.Printf("OK -- %s passed\n", testName);
  } else {
    fmt.Printf("FAIL -- %s failed;\n  - exp '%s'\n  - got '%s'\n", testName, exp, got)
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

func Decode(input []string) string {
  code := ""
  currentKey := "5"

  for _, moves := range(input) {
    currentKey = NewKey(currentKey, moves)
    code += currentKey
  }
  return code
}

func NewKey(key, moves string) string {
  moveUp := map[string]string{
    "1": "1", "2": "2", "3": "3", 
    "4": "1", "5": "2", "6": "3", 
    "7": "4", "8": "5", "9": "6", 
  }
  moveDown := map[string]string{
    "1": "4", "2": "5", "3": "6", 
    "4": "7", "5": "8", "6": "9", 
    "7": "7", "8": "8", "9": "9", 
  }
  moveLeft := map[string]string{
    "1": "1", "2": "1", "3": "2", 
    "4": "4", "5": "4", "6": "5", 
    "7": "7", "8": "7", "9": "8", 
  }
  moveRight := map[string]string{
    "1": "2", "2": "3", "3": "3", 
    "4": "5", "5": "6", "6": "6", 
    "7": "8", "8": "9", "9": "9", 
  }

  for _, move := range(moves) {
    switch move {
    case 'U': key = moveUp[key]
    case 'D': key = moveDown[key]
    case 'L': key = moveLeft[key]
    case 'R': key = moveRight[key]
    }
  }
  return key
}