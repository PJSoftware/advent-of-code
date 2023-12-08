package main

import (
	"fmt"
	"regexp"
	"strconv"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type Disc struct {
	Number   int
	PosCount int
	CurrPos  int
}

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")

	testInput := []string{
		"Disc #1 has 5 positions; at time=0, it is at position 4.",
		"Disc #2 has 2 positions; at time=0, it is at position 1.",
	}
	testDiscs := Parse(testInput)
	advent.Test("Test", 5, Solve(testDiscs))
	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	input := advent.InputStrings("15")
	discs := Parse(input)
	fmt.Printf("Solution: %d\n", Solve(discs))
}

// Solution code

func Parse(input []string) []*Disc {
	discs := []*Disc{}

	re := regexp.MustCompile("Disc #([0-9]+) has ([0-9]+) positions; at time=0, it is at position ([0-9]+)[.]")
	for _, line := range input {
		matches := re.FindStringSubmatch(line)
		if matches != nil {
			disc := &Disc{}
			disc.Number = ExtractInt(matches[1])
			disc.PosCount = ExtractInt(matches[2])
			disc.CurrPos = ExtractInt(matches[3])
			discs = append(discs, disc)
		}
	}
	return discs
}

func ExtractInt(str string) int {
	i, _ := strconv.ParseInt(str, 10, 64)
	return int(i)
}

// Solve() returns the time-tick at which the button should be pressed.
//
// My approach here, rather than performing a complete simulation of the system,
// is to first rotate each disc by its position in the stack (ie, disc 1 gets
// rotated by 1, disc 2 by 2, etc). This ensures that the discs all reflect the
// position they would be at when the capsule actually reached them, so we can
// simply examine all discs for position = 0 and if they all match, we have our
// answer.
//
// At first I thought it might be as simple as multiplying all the position
// counts -- but it gets complicated rapidly, and having "random" starting
// positions further complicates the possible formula. The semi-simulation seems
// the easier approach.
func Solve(discs []*Disc) int {
	Show(discs)
	for _, disc := range discs {
		disc.Adjust()
	}

	tick := 0
	for {
		Show(discs, tick)
		if AtZero(discs) {
			return tick
		}

		tick++
		for _, disc := range discs {
			disc.StepForward()
		}
	}
}

func (d *Disc) StepForward() {
	d.CurrPos++
	if d.CurrPos == d.PosCount {
		d.CurrPos = 0
	}
}

func (d *Disc) Adjust() {
	d.CurrPos += d.Number
	for d.CurrPos >= d.PosCount {
		d.CurrPos -= d.PosCount
	}
}

func AtZero(discs []*Disc) bool {
	for _, disc := range discs {
		if disc.CurrPos != 0 {
			return false
		}
	}
	return true
}

// Show() added because my first thought (**rewind** each disc by its position
// on the stack) was wrong. Commented out because it slows us down too much.
func Show(discs []*Disc, tick ...int) {
	// if len(tick) == 0 {
	// 	fmt.Printf("Before adjustment:\n")
	// } else {
	// 	fmt.Printf("At tick %d:\n", tick[0])
	// }

	// for _, disc := range discs {
	// 	fmt.Printf("  - Disc %d (with %d positions) is at position %d\n", disc.Number, disc.PosCount, disc.CurrPos)
	// }
}
