package main

import (
	"fmt"
	"strings"

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
	row := room.FirstRow
	room.SafeCount += countSafeSpaces(row)
	for i := 1; i < room.NumRows; i++ {
		row = generateNextRow(row)
		room.SafeCount += countSafeSpaces(row)
	}
	return room.SafeCount
}

func generateNextRow(oldRow string) string {
	length := len(oldRow)
	oldRow = SafeTile + oldRow + SafeTile // Add assumed safe tile at each end of row

	row := ""
	for i := 1; i <= length; i++ {
		above := oldRow[i-1 : i+2]
		if above == "^^." || above == ".^^" || above == "^.." || above == "..^" {
			row += TrapTile
		} else {
			row += SafeTile
		}
	}
	return row
}

func countSafeSpaces(row string) int {
	return len(strings.ReplaceAll(row, TrapTile, ""))
}
