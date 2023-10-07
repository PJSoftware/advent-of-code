package advent

import (
	"log"
	"os"
)

func ReadString(fn string) string {
	b, err := os.ReadFile(fn)
	if err != nil {
		log.Fatalf("error reading '%s': %v", fn, err)
	}

	return string(b)
}