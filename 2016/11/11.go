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
  ElevatorMoves int
}

type Move struct {
  Dir Direction
  Equip1 *Equip
  Equip2 *Equip
}

func NewLayout() *Layout {
  l := &Layout{}
  l.MinFloor = Floor1
  l.MaxFloor = Floor4
  l.ElevatorOnFloor = Floor1
  l.ElevatorMoves = 0
  return l
}

func NewMove(dir Direction, eq1, eq2 *Equip) *Move {
  m := &Move{}
  m.Dir = dir
  m.Equip1 = eq1
  m.Equip2 = eq2
  return m
}

func (m *Move) Describe() string {
  dir := ""
  switch m.Dir {
  case Up: dir = "up"
  case Down: dir = "down"
  }
  if m.Equip2 == nil {
    return fmt.Sprintf("Move %s %s", m.Equip1.Name(), dir)
  }

  return fmt.Sprintf("Move %s and %s %s", m.Equip1.Name(), m.Equip2.Name(), dir)
}

func (l *Layout) Describe() string {
  desc := fmt.Sprintf("LAYOUT:%d",l.ElevatorOnFloor)
  for _, eq := range(l.Equipment) {
    desc += fmt.Sprintf(":%s(%d)", eq.Name(), eq.OnFloor)
  }
  return desc
}

func (l *Layout) AddToFloor(floor Floor, eq *Equip) {
  eq.OnFloor = floor
  l.Equipment = append(l.Equipment, eq)
}

func (l *Layout) MovesRequired() int {
  layoutSeen := make(map[string]bool)
  allPossibleLayouts := []*Layout{}
  allPossibleLayouts = append(allPossibleLayouts, l)
  moves := 0

  for {
    nextLayouts := []*Layout{}

    if len(allPossibleLayouts) == 0 {
      return -1
    }

    for _, layout := range(allPossibleLayouts) {
      if layout.IsFinal() {
        return layout.ElevatorMoves
      }
    }

    for _, layout := range(allPossibleLayouts) {
      if !layoutSeen[layout.Describe()] && layout.IsValid() {
        layoutSeen[layout.Describe()] = true
        moves := layout.PossibleMoves()
        for _, move := range(moves) {
          nextLayouts = append(nextLayouts, layout.Apply(move))
        }
      }
    }

    allPossibleLayouts = nil
    allPossibleLayouts = append(allPossibleLayouts, nextLayouts...)
    moves++
  }

}

func (l *Layout) IsFinal() bool {
  for _, eq := range(l.Equipment) {
    if eq.OnFloor != Floor4 {
      return false
    }
  }

  return true
}

func (l *Layout) IsValid() bool {
  chipFloor := make(map[Element]Floor)
  genFloor := make(map[Element]Floor)

  for _, eq := range(l.Equipment) {
    if eq.Type == Microchip {
      chipFloor[eq.Element] = eq.OnFloor
    } else {
      genFloor[eq.Element] = eq.OnFloor
    }
  }

  for cEl := range(chipFloor) {
    if genFloor[cEl] != chipFloor[cEl] { // Chip is not protected
      for gEl := range(chipFloor) {
        if gEl != cEl {
          if genFloor[gEl] == chipFloor[cEl] { // Unprotected chip on same floor as another generator
            return false
          }
        }
      }
    }
  }

  return true
}

// l.Apply() generates a new layout by applying the specified move to the
// current layout
func (l *Layout) Apply(move *Move) *Layout {
  nl := &Layout{}
  nl.MinFloor = Floor1
  nl.MaxFloor = Floor4
  nl.ElevatorOnFloor = l.ElevatorOnFloor + Floor(move.Dir)
  nl.ElevatorMoves = l.ElevatorMoves + 1

  for _, eq := range(l.Equipment) {
    floor := eq.OnFloor
    if move.Equip1.Element == eq.Element && move.Equip1.Type == eq.Type {
      floor += Floor(move.Dir)
    } else if move.Equip2 != nil && move.Equip2.Element == eq.Element && move.Equip2.Type == eq.Type {
      floor += Floor(move.Dir)
    }
    nl.AddToFloor(floor, NewEquip(eq.Element,eq.Type))
  }

  return nl
}

func (l *Layout) PossibleMoves() []*Move {
  canMove := l.ObjectsWithElevator()

  moves := []*Move{}
  if len(canMove) == 0 {
    return moves
  }

  if len(canMove) == 1 {
    if l.ElevatorOnFloor < Floor4 {
      moves = append(moves, NewMove(Up, canMove[0], nil))
    }
    if l.ElevatorOnFloor > Floor1 {
      moves = append(moves, NewMove(Down, canMove[0], nil))
    }
    return moves
  }
  
  for _, eq := range(canMove) {
    if l.ElevatorOnFloor < Floor4 {
      moves = append(moves, NewMove(Up, eq, nil))
    }
    if l.ElevatorOnFloor > Floor1 {
      moves = append(moves, NewMove(Down, eq, nil))
    }
  }
  
  for i := 0; i < len(canMove)-1; i++ {
    for j := i+1; j < len(canMove); j++ {
      if l.ElevatorOnFloor < Floor4 {
        moves = append(moves, NewMove(Up, canMove[i], canMove[j]))
      }
      if l.ElevatorOnFloor > Floor1 {
        moves = append(moves, NewMove(Down, canMove[i], canMove[j]))
      }
    }
  }

  return moves
}

func (l *Layout) ObjectsWithElevator() []*Equip {
  list := []*Equip{}
  for _, eq := range(l.Equipment) {
    if eq.OnFloor == l.ElevatorOnFloor {
      list = append(list, eq)
    }
  }
  return list
}