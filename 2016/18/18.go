package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type TrapDetector struct {
	FirstRow  string
	NumRows   int
	SafeCount int
}

const TrapTile string = "^"
const TrapSym string = "❌"
const SafeTile string = "."
const SafeSym string = "🟩"

func NewDetector(row string, rows int) *TrapDetector {
	d := &TrapDetector{FirstRow: row, NumRows: rows, SafeCount: 0}
	return d
}

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")

	advent.Test("room1", 6, Solve(NewDetector("..^^.", 3)))
	advent.Test("room2", 38, Solve(NewDetector(".^^.^.^^^^", 10)))
	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	input := advent.InputString("18")
	fmt.Printf("Solution: %d\n", Solve(NewDetector(input, 40)))
}

// Solution code

func Solve(room *TrapDetector) int {
	return room.SafeCount
}
