package advent

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func inputFile(num string) string {
	return fmt.Sprintf("C:/_dev/advent-of-code/2016/%s/%s-input.txt",num,num)
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

// InputString reads the contents of the input file line by line, and returns it as a slice of strings
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
		slice = append(slice, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
			log.Fatalf("error reading '%s': %v", fn, err)
	}
	
	return slice
}
