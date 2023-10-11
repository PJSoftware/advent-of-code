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
  testDisplay := NewDisplay(7,3)
  testCommands := []string{
    "rect 3x2",
    "rotate column x=1 by 1",
    "rotate row y=0 by 4",
    "rotate column x=1 by 1",
  }
  for _, testCmd := range(testCommands) {
    testDisplay.Interpret(testCmd)
    testDisplay.Show()
  }
  advent.Test("pixels on", 6, testDisplay.onCount)
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputStrings("08")
  display := NewDisplay(50,6)
  for _, cmd := range(input) {
    display.Interpret(cmd)
  }
  display.Show()
  fmt.Printf("Solution: %d\n",display.onCount)
}

// Solution code

type Display struct {
  x int // number of columns
  y int // number of rows
  display [][]bool
  onCount int
}

func NewDisplay(x, y int) *Display {
  d := &Display{}
  d.x = x
  d.y = y
  d.display = make([][]bool, x)
  for i := range(d.display) {
    d.display[i] = make([]bool, y)
  }
  d.onCount = 0
  return d
}

func (d *Display) Interpret(cmd string) {
  reRect := regexp.MustCompile(`rect (\d+)x(\d+)`)
  match := reRect.FindStringSubmatch(cmd)
  if match != nil {
    d.rect(Intify(match[1],match[2]))
    return
  }
  
  reRotRow := regexp.MustCompile(`rotate row y=(\d+) by (\d+)`)
  match = reRotRow.FindStringSubmatch(cmd)
  if match != nil {
    d.rotateRow(Intify(match[1],match[2]))
    return
  }
  
  reRotCol := regexp.MustCompile(`rotate column x=(\d+) by (\d+)`)
  match = reRotCol.FindStringSubmatch(cmd)
  if match != nil {
    d.rotateCol(Intify(match[1],match[2]))
    return
  }

  log.Fatalf("command '%s' not recognised", cmd)
}

func (d *Display) rect(x, y int) {
  d.Validate(x-1,y-1)
  for j := 0; j < y; j++ {
    for i := 0; i < x; i++ {
      d.TurnOn(i,j)
    }
  }
}

func (d *Display) rotateRow(y, by int) {
  if by == 0 {
    return
  }

  d.Validate(0,y)
  ofCell := d.display[d.x-1][y]
  for i := d.x-1; i >= 0; i-- {
    if i == 0 {
      d.display[i][y] = ofCell
    } else {
      d.display[i][y] = d.display[i-1][y]
    } 
  }
  d.rotateRow(y, by-1)
}

func (d *Display) rotateCol(x, by int) {
  if by == 0 {
    return
  }
  
  d.Validate(x,0)
  ofCell := d.display[x][d.y-1]
  for j := d.y-1; j >= 0; j-- {
    if j == 0 {
      d.display[x][j] = ofCell
    } else {
      d.display[x][j] = d.display[x][j-1]
    } 
  }
  d.rotateCol(x, by-1)
}

func (d *Display) TurnOn(x, y int) {
  d.Validate(x,y)

  if !d.display[x][y] {
    d.onCount++
  }
  d.display[x][y] = true
}

func (d *Display) Show() {
  for j := 0; j <= d.y-1; j++ {
    for i := 0; i <= d.x-1; i++ {
      if d.display[i][j] {
        fmt.Print("#")
      } else {
        fmt.Print(" ")
      }
    }
    fmt.Println()
  }
  fmt.Println()
}

func (d *Display) Validate(x, y int) {
  if x >= d.x {
    log.Fatalf("(%d,%d): Value of x (%d) >= display_x (%d)", x,y, x,d.x)
  }
  if y >= d.y {
    log.Fatalf("(%d,%d): Value of y (%d) >= display_y (%d)", x,y, y,d.y)
  }
}

func Intify(a,b string) (int, int) {
  i, err := strconv.Atoi(a)
  if err != nil {
    log.Fatalf("error converting '%v': %v", a, err)
  }
  j, err := strconv.Atoi(b)
  if err != nil {
    log.Fatalf("error converting '%v': %v", b, err)
  }
  return i, j
}