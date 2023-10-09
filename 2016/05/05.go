package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")
  advent.Test("password generation", "18f47a30", genPassword("abc"))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");

  // Solution
  
  input := advent.InputString("05")
  fmt.Printf("Password for '%s': %s\n",input, genPassword(input))
}

// Solution code

func genPassword(seed string) string {
  id := 0

  pwd := ""
  for {
    src := fmt.Sprintf("%s%d", seed, id)
    hash := GetMD5Hash(src)
    if hash[:5] == "00000" {
      fmt.Printf("Found: %s -> %s\n", src, hash)
      pwd += string(hash[5])
      if len(pwd) == 8 {
        return pwd
      }
    }
    id++
  }
}

func GetMD5Hash(text string) string {
  hash := md5.Sum([]byte(text))
  return hex.EncodeToString(hash[:])
}