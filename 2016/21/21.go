package main

import (
	"fmt"
	"log"
	"regexp"
	"strconv"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type Parser struct {
  // `swap position X with position Y` means that the letters at indexes X and Y (counting from 0) should be swapped.
  SwapPos *regexp.Regexp
  // `swap letter X with letter Y` means that the letters X and Y should be swapped (regardless of where they appear in the string).
  SwapLetter *regexp.Regexp
  // `rotate left X steps` means that the whole string should be rotated; for example, one left rotation would turn abcd into bcda.
  RotLeft *regexp.Regexp
  // `rotate right X steps` means that the whole string should be rotated; for example, one right rotation would turn abcd into dabc.
  RotRight *regexp.Regexp
  // `rotate based on position of letter X` means that the whole string should be rotated to the right based on the index of letter X (counting from 0) as determined before this instruction does any rotations. Once the index is determined, rotate the string to the right one time, plus a number of times equal to that index, plus one additional time if the index was at least 4.
  RotPos *regexp.Regexp
  // `reverse positions X through Y` means that the span of letters at indexes X through Y (including the letters at X and Y) should be reversed in order.
  Reverse *regexp.Regexp
  // `move position X to position Y` means that the letter which is at index X should be removed from the string, then inserted such that it ends up at index Y.
  MovePos *regexp.Regexp
}

func NewCodeParser() *Parser {
  p := &Parser{}

  p.SwapPos = regexp.MustCompile("swap position ([0-9]) with position ([0-9])")
  p.SwapLetter = regexp.MustCompile("swap letter ([a-z]) with letter ([a-z])")
  p.RotLeft = regexp.MustCompile("rotate left ([0-9]) steps?")
  p.RotRight = regexp.MustCompile("rotate right ([0-9]) steps?")
  p.RotPos = regexp.MustCompile("rotate based on position of letter ([a-z])")
  p.Reverse = regexp.MustCompile("reverse positions ([0-9]) through ([0-9])")
  p.MovePos = regexp.MustCompile("move position ([0-9]) to position ([0-9])")

  return p
}

func main() {
  // Tests

  parser := NewCodeParser()

  testData := "abcde"
  testCode := []string{
    "swap position 4 with position 0|ebcda",
    "swap letter d with letter b|edcba",
    "reverse positions 0 through 4|abcde",
    "rotate left 2 steps|cdeab",
    "rotate right 1 step|bcdea",
    "move position 1 to position 4|bdeac",
    "move position 3 to position 0|abdec",
    "rotate based on position of letter b|ecabd",
    "rotate based on position of letter d|decab",
  }
  fmt.Print("Starting Tests:\n\n")
  for _, code := range testCode {
    data := strings.Split(code, "|")
    result := parser.ExecuteCode(data[0], testData)
    advent.Test(fmt.Sprintf("Exec '%s' on '%s'", data[0], testData), data[1], result)
    testData = data[1] // Use what it SHOULD be for next input, not what we got
  }
  advent.Test("whole program", "decab", parser.RunProgram(testCode, "abcde"))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  program := advent.InputStrings("21")
  fmt.Printf("Solution: %s\n", parser.RunProgram(program, "abcdefgh"))
}

// Solution code

func (p *Parser) RunProgram(prog []string, password string) string {
  l := len(password)
  step := 0
  for _, code := range prog {
    step++
    password = p.ExecuteCode(code, password)
    if len(password) != l {
      log.Fatalf("Step %d: '%s' returned invalid length '%s'\n",step, code, password)
    }
  }
  return password
}

func (p *Parser) ExecuteCode(code string, password string) string {
  switch {
  case p.SwapPos.MatchString(code): password = p.ExecSwapPos(code, password)
  case p.SwapLetter.MatchString(code): password = p.ExecSwapLetter(code, password)
  case p.RotLeft.MatchString(code): password = p.ExecRotLeft(code, password)
  case p.RotRight.MatchString(code): password = p.ExecRotRight(code, password)
  case p.RotPos.MatchString(code): password = p.ExecRotPos(code, password)
  case p.Reverse.MatchString(code): password = p.ExecReverse(code, password)
  case p.MovePos.MatchString(code): password = p.ExecMovePos(code, password)
  default: log.Fatalf("string '%s' not recognised!", code)
  }

  return password
}

func (p *Parser) ExecSwapPos(code, password string) string {
  match := p.SwapPos.FindStringSubmatch(code)
  idxX := convertToInt(match[1])
  idxY := convertToInt(match[2])
  b := []byte(password) 
  b[idxX], b[idxY] = b[idxY], b[idxX]
  return string(b)
}

func (p *Parser) ExecSwapLetter(code, password string) string {
  match := p.SwapLetter.FindStringSubmatch(code)
  idxX := strings.Index(password, match[1])
  idxY := strings.Index(password, match[2])
  b := []byte(password)
  b[idxX], b[idxY] = b[idxY], b[idxX]
  return string(b)
}

func (p *Parser) ExecRotLeft(code, password string) string {
  match := p.RotLeft.FindStringSubmatch(code)
  x := convertToInt(match[1])
  return rotateLeft(password, x)
}

func (p *Parser) ExecRotRight(code, password string) string {
  match := p.RotRight.FindStringSubmatch(code)
  x := convertToInt(match[1])
  return rotateRight(password, x)
}

func (p *Parser) ExecRotPos(code, password string) string {
  match := p.RotPos.FindStringSubmatch(code)
  idxX := strings.Index(password, match[1])
  x := idxX + 1
  if idxX >= 4 {
    x++
  }
  return rotateRight(password, x)
}

func (p *Parser) ExecReverse(code, password string) string {
  match := p.Reverse.FindStringSubmatch(code)
  idxX := convertToInt(match[1])
  idxY := convertToInt(match[2])
  b := []byte(password)
  for i, j := idxX, idxY; i < j; i, j = i+1, j-1 {
    b[i], b[j] = b[j], b[i]
  }
  return string(b)
}

func (p *Parser) ExecMovePos(code, password string) string {
  match := p.MovePos.FindStringSubmatch(code)
  idxX := convertToInt(match[1])
  idxY := convertToInt(match[2])
  ch := password[idxX:idxX+1]
  
  b := []byte{}
  if idxX == 0 {
    b = append(b, []byte(password[idxX+1:])...)
  } else if idxX == len(password) - 1 {
    b = append(b, []byte(password[:idxX])...)
  } else {
    b = append(b, []byte(password[:idxX])...)
    b = append(b, []byte(password[idxX+1:])...)
  }
  temp := string(b)

  if idxY == 0 {
    return ch + temp
  }
  if idxY == len(password) - 1 {
    return temp + ch
  }

  return temp[:idxY] + ch + temp[idxY:]
}

func convertToInt(s string) int {
  i, err := strconv.ParseInt(s, 10, 64)
  if err != nil {
    log.Fatalf("Unexpected conversion error, '%s' not numeric!", s)
  }
  return int(i)
}

func rotateLeft(password string, x int) string {
  if x == 0 {
    return password
  }

  for i := 1; i<=x; i++ {
    b := []byte(password[1:])
    b = append(b, []byte(password[0:1])...)
    password = string(b)
  }
  return password
}

func rotateRight(password string, x int) string {
  if x == 0 {
    return password
  }

  n := len(password)
  for i := 1; i<=x; i++ {
    b := []byte(password[n-1:n])
    b = append(b, []byte(password[0:n-1])...)
    password = string(b)
  }
  return password
}
