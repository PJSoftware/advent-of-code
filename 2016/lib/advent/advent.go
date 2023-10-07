package advent

import (
	"fmt"
	"log"
	"os"
)

func InputString(dayNumber string) string {
	path := fmt.Sprintf("C:/_dev/advent-of-code/2016/%s/%s-input.txt",dayNumber,dayNumber)
	b, err := os.ReadFile(path)
	if err != nil {
		log.Fatalf("error reading '%s': %v", path, err)
	}

	return string(b)
}