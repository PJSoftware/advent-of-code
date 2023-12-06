package main

import (
	"fmt"
	"os"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type Floor int
const (
  Elevator Floor = iota
  Floor1
  Floor2
  Floor3
  Floor4
)
type Direction int
const (
  Up Direction = 1
  Parked Direction = 0
  Down Direction = -1
)

type Safety int
const (
  AlwaysSafe Safety = iota
  Protected
  Unprotected
)

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")

  testLayout := NewLayout()
  testLayout.AddToFloor(Floor1, NewEquip(Hydrogen,Microchip))
  testLayout.AddToFloor(Floor1, NewEquip(Lithium,Microchip))
  testLayout.AddToFloor(Floor2, NewEquip(Hydrogen,Generator))
  testLayout.AddToFloor(Floor3, NewEquip(Lithium,Generator))

  advent.Test("moves required", 11, testLayout.MovesRequired())
  advent.BailOnFail()

  fmt.Print("All tests passed!\n\n");
  os.Exit(1)
  
  // Solution

  layout := NewLayout()
  layout.AddToFloor(Floor1, NewEquip(Strontium,Generator))
  layout.AddToFloor(Floor1, NewEquip(Strontium,Microchip))
  layout.AddToFloor(Floor1, NewEquip(Plutonium,Generator))
  layout.AddToFloor(Floor1, NewEquip(Plutonium,Microchip))
  layout.AddToFloor(Floor2, NewEquip(Thulium,Generator))
  layout.AddToFloor(Floor3, NewEquip(Thulium,Microchip))
  layout.AddToFloor(Floor2, NewEquip(Ruthenium,Generator))
  layout.AddToFloor(Floor2, NewEquip(Ruthenium,Microchip))
  layout.AddToFloor(Floor2, NewEquip(Curium,Generator))
  layout.AddToFloor(Floor2, NewEquip(Curium,Microchip))
  fmt.Printf("Solution: %d\n",layout.MovesRequired())
}

// Solution code

type Layout struct {
  Equipment []*Equip

  MinFloor Floor
  MaxFloor Floor
  ElevatorOnFloor Floor
  ElevatorMove Direction
  ElevatorMoves int
}

func NewLayout() *Layout {
  l := &Layout{}
  l.MinFloor = Floor1
  l.MaxFloor = Floor4
  l.ElevatorOnFloor = Floor1
  l.ElevatorMove = Parked
  l.ElevatorMoves = 0
  return l
}

func (l *Layout) AddToFloor(floor Floor, eq *Equip) {
  eq.OnFloor = floor
  l.Equipment = append(l.Equipment, eq)
}

func (l *Layout) MovesRequired() int {
  return 1
}

