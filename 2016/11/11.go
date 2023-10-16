package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type Floor int
type Element int
const (
  NoElement Element = iota
  Hydrogen
  Lithium
)

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")

  testLayout := NewLayout(4)
  testLayout.AddEquip(Hydrogen, 1, 2)
  testLayout.AddEquip(Lithium, 1, 3)

  advent.Test("moves required", 11, testLayout.MovesRequired())
  advent.BailOnFail()

  fmt.Print("All tests passed!\n\n");
  
  // Solution

  layout := NewLayout(4)
  fmt.Printf("Solution: %d\n",layout.MovesRequired())
}

// Solution code

type Layout struct {
  Generators map[Element]Floor
  Microchips map[Element]Floor
  OnElevatorGen Element
  OnElevatorChip Element
  ElevatorOnFloor Floor
  MinFloor Floor
  MaxFloor Floor
  ElevatorMoves int
}

func NewLayout(floors Floor) *Layout {
  l := &Layout{}
  l.Generators = make(map[Element]Floor)
  l.Microchips = make(map[Element]Floor)
  l.MinFloor = 1
  l.MaxFloor = floors
  l.ElevatorOnFloor = 1
  l.ElevatorMoves = 0
  return l
}

func (l *Layout) AddEquip(el Element, chipFloor, genFloor Floor) {
  l.Microchips[el] = chipFloor
  l.Generators[el] = genFloor
}

func (l *Layout) MovesRequired() int {
  return 0
}