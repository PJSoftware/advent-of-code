package main

import (
	"fmt"
	"math"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")
	advent.Test("sample1", 3, SolveOriginal(5))

	var n int
	n = 1
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 1, SolveRevised(n))
	n = 2
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 1, SolveRevised(n))
	n = 3
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 3, SolveRevised(n))
	n = 4
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 1, SolveRevised(n))
	n = 5
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 2, SolveRevised(n))
	n = 9
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 9, SolveRevised(n))
	n = 10
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 1, SolveRevised(n))
	n = 18
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 9, SolveRevised(n))
	n = 19
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 11, SolveRevised(n))
	n = 55
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 29, SolveRevised(n))
	n = 242
	advent.Test(fmt.Sprintf("sample2 (%d elves)", n), 241, SolveRevised(n))
	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	input := advent.InputInt("19")
	fmt.Printf("Solution 1: %d\n", SolveOriginal(input))
	fmt.Printf("Solution 2 (n = %d): %d\n", input, SolveRevised(input))
}

// Solution code

func SolveOriginal(numElves int) int {
	round := 1
	active := 1
	nextElfWithPresents := map[int]int{}

	for {
		if round == 1 {
			next := active + 2 // because the 'active+1' elf misses out immediately
			if next == numElves {
				round++
				nextElfWithPresents[active] = next
				nextElfWithPresents[next] = nextElfWithPresents[1]
				active = nextElfWithPresents[1]
				delete(nextElfWithPresents, 1)

			} else if next == numElves-1 {
				round++
				nextElfWithPresents[active] = next
				nextElfWithPresents[next] = 1
				active = 1

			} else {
				nextElfWithPresents[active] = active + 2
				active = nextElfWithPresents[active]
			}

			// round > 1; after the first we don't care
		} else {
			next := nextElfWithPresents[active]
			nextElfWithPresents[active] = nextElfWithPresents[next]
			active = nextElfWithPresents[next]
			delete(nextElfWithPresents, next)
			if len(nextElfWithPresents) == 1 {
				return active
			}
		}
	}
}

// SolveRevised() calculates our pattern derived by inspection
// because the algorithmic approach takes far too long for
// large numbers. See 1-100 results in README
func SolveRevised(numElves int) int {
	x := 0
	lim := 1
	preLim := 1
	for lim < numElves {
		preLim = lim
		x++
		lim = int(math.Pow(3, float64(x)))
	}

	if numElves == lim {
		return lim
	}

	if numElves <= preLim*2 {
		return numElves - preLim
	}

	return lim - 2*(lim-numElves)
}
