package main

import (
	"fmt"
	"time"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")
	advent.Test("sample1", 3, SolveOriginal(5))
	advent.Test("sample2", 2, SolveRevised(5))
	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	input := advent.InputInt("19")
	fmt.Printf("Solution 1: %d\n", SolveOriginal(input))
	fmt.Printf("Solution 2: %d\n", SolveRevised(input))
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

func SolveRevised(numElves int) int {
	oc := float64(numElves)
	round := 1
	Elf := make([]int, 0)
	for n := 1; n <= numElves; n++ {
		Elf = append(Elf, n)
	}

	start := time.Now()
	for {
		if numElves%5000 == 0 {
			pc := 100.0 * float64(numElves) / oc
			rem := 100.0 - pc
			elapsed := time.Since(start)
			rt := elapsed * time.Duration(100.0/rem-1.0)
			fmt.Printf("Number of elves remaining: %d (remaining: %s)\n", numElves, rt)
		}

		if len(Elf) == 2 {
			elapsed := time.Since(start)
			fmt.Printf("Total elapsed time: %s\n", elapsed)
			return Elf[0]
		}

		opposite := numElves / 2
		Elf[opposite] = 0

		newCircle := make([]int, 0)
		newCircle = append(newCircle, Elf[1:opposite]...)
		newCircle = append(newCircle, Elf[opposite+1:numElves]...)
		newCircle = append(newCircle, Elf[0])
		numElves = len(newCircle)

		Elf = make([]int, 0)
		Elf = append(Elf, newCircle...)
		round++
	}
}
