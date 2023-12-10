package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")
	advent.Test("sample1", 3, Solve(5))
	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	input := advent.InputInt("19")
	fmt.Printf("Solution: %d\n", Solve(input))
}

// Solution code

func Solve(numElves int) int {
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
