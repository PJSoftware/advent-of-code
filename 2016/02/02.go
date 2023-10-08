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

  testExpActual := "5DB3"
  testGotActual := DecodeActual(testData)
  TestSampleData("testCodeActual",testExpActual,testGotActual)

  BailOnFail()

  input := advent.InputStrings("02")
  fmt.Printf("Solution: %s\n",Decode(input))
  fmt.Printf("Actual Solution: %s\n",DecodeActual(input))
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

func DecodeActual(input []string) string {
  code := ""
  currentKey := "5"

  for _, moves := range(input) {
    currentKey = NewKeyActual(currentKey, moves)
    code += currentKey
  }
  return code
}

func NewKeyActual(key, moves string) string {
  moveUp := map[string]string{
    "1": "1", "2": "2", "3": "1", 
    "4": "4", "5": "5", "6": "2", 
    "7": "3", "8": "4", "9": "9", 
    "A": "6", "B": "7", "C": "8", "D": "B",
  }
  moveDown := map[string]string{
    "1": "3", "2": "6", "3": "7", 
    "4": "8", "5": "5", "6": "A", 
    "7": "B", "8": "C", "9": "9", 
    "A": "A", "B": "D", "C": "C", "D": "D",
  }
  moveLeft := map[string]string{
    "1": "1", "2": "2", "3": "2", 
    "4": "3", "5": "5", "6": "5", 
    "7": "6", "8": "7", "9": "8", 
    "A": "A", "B": "A", "C": "B", "D": "D",
  }
  moveRight := map[string]string{
    "1": "1", "2": "3", "3": "4", 
    "4": "4", "5": "6", "6": "7", 
    "7": "8", "8": "9", "9": "9", 
    "A": "B", "B": "C", "C": "C", "D": "D",
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