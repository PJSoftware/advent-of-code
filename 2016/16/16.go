package main

import (
	"fmt"
	"log"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

var csLookup = make(map[string]string)

const CacheStringLength = 256

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")

	dcGenTests := make(map[string]string)
	dcGenTests["1"] = "100"
	dcGenTests["0"] = "001"
	dcGenTests["11111"] = "11111000000"
	dcGenTests["111100001010"] = "1111000010100101011110000"
	for testInputDC, testExpDC := range dcGenTests {
		advent.Test("dragon curve", testExpDC, DragonCurve(testInputDC, 0))
	}

	checksumTests := make(map[string]string)
	checksumTests["110010110100"] = "100"
	checksumTests["0011010110101101"] = "0"
	checksumTests["0000000000000000"] = "1"
	checksumTests["110010110100"] = "100"
	for testInputCS, testExpCS := range checksumTests {
		advent.Test("checksum", testExpCS, Checksum(testInputCS))
	}

	testInput := "10000"
	testLength := 20
	testCS := "01100"
	testExp := "10000011110010000111"
	advent.Test("final data", testExp, DragonCurve(testInput, testLength))
	advent.Test("final sum", testCS, Solve(testInput, testLength))

	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	input := advent.InputString("16")
	len1 := 272
	len2 := 35651584
	fmt.Printf("Solution: %s\n", Solve(input, len1))
	fmt.Printf("Solution: %s\n", Solve(input, len2))
	fmt.Printf("> Maximum cached %d-byte checksums: %d\n", CacheStringLength, len(csLookup))
}

// Solution code

func DragonCurve(a string, minLen int) string {
	n := 0
	for {
		n++
		b := flipBits(reverse(a))
		dc := a + "0" + b
		if minLen == 0 {
			return dc
		}
		if len(dc) >= minLen {
			return dc[:minLen]
		}
		a = dc
	}
}

func flipBits(a string) string {
	b := strings.ReplaceAll(a, "0", "x")
	b = strings.ReplaceAll(b, "1", "0")
	b = strings.ReplaceAll(b, "x", "1")
	return b
}

func reverse(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}

func Checksum(s string) string {
	for {
		if len(s) < 1024 {
			return CalcChecksum(s)
		}

		if len(s)%CacheStringLength == 0 {
			rv := ""
			for idx := 0; idx < len(s); idx += CacheStringLength {
				rv += CalcChecksum(s[idx : idx+CacheStringLength])
			}
			s = rv
		} else {
			log.Fatalf("Well I'm all out of ideas")
		}
	}
}

func CalcChecksum(a string) string {
	csCache := false
	csKey := ""
	if len(a) == CacheStringLength {
		if cs, ok := csLookup[a]; ok {
			return cs
		}
		csCache = true
		csKey = a
	}

	for {
		if len(a)%2 != 0 {
			if csCache {
				csLookup[csKey] = a
				fmt.Printf("Caching %s -> %s\n", csKey, a)
			}
			return a
		}

		rv := ""
		for idx := 0; idx < len(a); idx += 2 {
			if a[idx:idx+1] == a[idx+1:idx+2] {
				rv += "1"
			} else {
				rv += "0"
			}
		}

		a = rv
	}
}

func Solve(input string, minLength int) string {
	return Checksum(DragonCurve(input, minLength))
}
