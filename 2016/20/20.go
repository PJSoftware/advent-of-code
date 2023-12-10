package main

import (
	"fmt"
	"log"
	"math"
	"slices"
	"strconv"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
	// Tests

	testBlacklist := []string{
		"5-8",
		"0-2",
		"4-7",
	}

	fmt.Print("Starting Tests:\n\n")
	advent.Test("test network", int(3), LowestAllowableIP(testBlacklist))
	advent.Test("test ip-count", 2, CountAvailable(testBlacklist, 0, 9))
	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	blacklist := advent.InputStrings("20")
	fmt.Printf("Lowest Allowable IP: %d\n", LowestAllowableIP(blacklist))
	fmt.Printf("# Available IPs: %d\n", CountAvailable(blacklist, 0, int(math.MaxUint32)))

}

// Solution code

func LowestAllowableIP(input []string) int {
	blackList := rationalise(input)
	return blackList[0].max + 1
}

func CountAvailable(input []string, rangeMin, rangeMax int) int {
	blackList := rationalise(input)

	rv := rangeMax - rangeMin + 1
	for _, rng := range blackList {
		rv -= (rng.max - rng.min + 1)
	}

	return rv
}

type Range struct {
	min int
	max int
}

func rationalise(input []string) []*Range {
	ranges := []*Range{}

	rangeMax := make(map[int]int)
	for _, row := range input {
		low, high := parse(row)
		rangeMax[low] = high
	}

	keys := make([]int, 0, len(rangeMax))
	for k := range rangeMax {
		keys = append(keys, k)
	}
	slices.Sort(keys)

	currentRange := &Range{min: keys[0], max: rangeMax[keys[0]]}
	for i := 1; i < len(keys); i++ {
		min := keys[i]
		max := rangeMax[min]
		if overlaps(min, max, currentRange) {
			if min < currentRange.min {
				currentRange.min = min
			}
			if max > currentRange.max {
				currentRange.max = max
			}
		} else {
			ranges = append(ranges, currentRange)
			currentRange = &Range{min: min, max: max}
		}
	}
	ranges = append(ranges, currentRange)
	return ranges
}

func overlaps(min, max int, currentRange *Range) bool {
	return min <= currentRange.max+1
}

func parse(row string) (int, int) {
	val := strings.Split(row, "-")
	if len(val) != 2 {
		log.Fatalf("Row '%s' does not mach expected nnn-nnn pattern", row)
	}

	n1, _ := strconv.ParseInt(val[0], 10, 64)
	n2, _ := strconv.ParseInt(val[1], 10, 64)
	return int(n1), int(n2)
}
