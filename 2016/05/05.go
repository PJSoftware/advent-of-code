package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strconv"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")
  advent.Test("first password generation", "18f47a30", genPassword("abc"))
  testPwd2 := genSecondPassword("abc")
  advent.Test("second password generation", "05ace8e3", testPwd2)
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");

  // Solution
  
  input := advent.InputString("05")
  fmt.Printf("Password for '%s': %s\n",input, genPassword(input))

  genSecondPassword(input)
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

func genSecondPassword(seed string) string {
  id := 0

  fmt.Print("DECRYPTING:\n\n")

  pwdChar := []string{"-","-","-","-","-","-","-","-"}
  found := 0
  fmt.Printf("PASSWORD: [ %s ]\r",strings.ToUpper(strings.Join(pwdChar, " ")))

  for {
    src := fmt.Sprintf("%s%d", seed, id)
    id++
    hash := GetMD5Hash(src)
    if hash[:5] == "00000" {
      position, err := strconv.Atoi(string(hash[5]))
      if err != nil {
        continue
      }
      if position > 7 {
        continue
      }
      ch := string(hash[6])

      if pwdChar[position] == "-" {
        pwdChar[position] = ch
        found++
        fmt.Printf("PASSWORD: [ %s ]\r",strings.ToUpper(strings.Join(pwdChar, " ")))
      }
    }
    if found == 8 {
      pwd := strings.Join(pwdChar,"")
      fmt.Printf("\n\nPASSWORD FOUND: %s\n",pwd)
      return pwd
    }
  }
}

func GetMD5Hash(text string) string {
  hash := md5.Sum([]byte(text))
  return hex.EncodeToString(hash[:])
}