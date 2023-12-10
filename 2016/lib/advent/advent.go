package advent

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"reflect"
	"strconv"
	"strings"
)

func inputFile(num string) string {
	pwd := os.Getenv("PWD")
	return fmt.Sprintf("%s/2016/%s/%s-input.txt", pwd, num, num)
}

// InputString reads the contents of the input file as a single string
func InputString(num string) string {
	fn := inputFile(num)
	b, err := os.ReadFile(fn)
	if err != nil {
		log.Fatalf("error reading '%s': %v", fn, err)
	}

	return string(b)
}

// InputInt reads the contents of the input file and converts to an int
func InputInt(num string) int {
	s := InputString(num)

	i, err := strconv.ParseInt(s, 10, 64)
	if err != nil {
		log.Fatalf("string '%s' from file not a numeric value!", s)
	}
	return int(i)
}

// InputString reads the contents of the input file line by line, and returns it
// as a slice of strings. By default, all leading and trailing space is removed,
// as are empty lines.
func InputStrings(num string) []string {
	var slice []string
	fn := inputFile(num)
	file, err := os.Open(fn)
	if err != nil {
		log.Fatalf("error opening '%s': %v", fn, err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		txt := scanner.Text()
		txt = strings.TrimSpace(txt)
		if txt != "" {
			slice = append(slice, txt)
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatalf("error reading '%s': %v", fn, err)
	}

	return slice
}

// Testing functions

var testsFailed int

func Test(testName string, exp any, got any) {
	if reflect.TypeOf(exp) != reflect.TypeOf(got) {
		log.Fatalf("exp '%v' vs got '%v'; not the same type! (%s vs %s)", exp, got, reflect.TypeOf(exp), reflect.TypeOf(got))
	}
	if got == exp {
		fmt.Printf("OK -- '%s' => %v / passed\n", testName, got)
	} else {
		fmt.Printf("FAIL -- '%s' failed;\n  - exp '%v';\n  - got '%v'\n", testName, exp, got)
		testsFailed++
	}
}

func BailOnFail() {
	if testsFailed > 0 {
		log.Fatalf("Sample Data Tests: %d failed", testsFailed)
	}
	fmt.Println()
}
