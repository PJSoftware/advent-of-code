package main

import (
	"fmt"

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
  
  // Solution

  layout := NewLayout()
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
  for l.Incomplete() {
    dir := l.LoadElevator()
    l.MoveElevator(dir)
  }
  return l.ElevatorMoves
}

func (l *Layout) LoadElevator() Direction {
  dir := Up
  count := 0
  for _, eq := range(l.Equipment) {
    if eq.OnFloor != l.ElevatorOnFloor {
      continue
    }
    count++
  }



  return dir
}

func (l *Layout) MoveElevator(dir Direction) {

}

func (l *Layout) Incomplete() bool {
  for _, eq := range(l.Equipment) {
    if eq.OnFloor != l.MaxFloor {
      return true
    }
  }
  return false
}

func (l *Layout) FindMatch(eq1 *Equip) *Equip {
  etMatch := EquipType(1-eq1.Type)

  for _, eq2 := range(l.Equipment) {
    if eq2.Element == eq1.Element && eq2.Type == etMatch {
      return eq2
    }
  }
  return nil
}
