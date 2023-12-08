package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")

  stretchFactor := 2016

  testSalt := "abc"
  advent.Test("64th OTP key index", 22728, Solve(testSalt, 0))
  advent.Test("64th OTP stretched key index", 22551, Solve(testSalt, stretchFactor))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");

  // Solution
  
  salt := advent.InputString("14")
  fmt.Printf("Index of 64th OTP key: %d\n",Solve(salt, 0))
  fmt.Printf("Index of 64th OTP key (stretched): %d\n",Solve(salt, stretchFactor))
}

// Solution code

type SolverData struct {
  salt string
  hash map[int]string
  keys []int
  sf int
}

func NewSolver(salt string, sf int) *SolverData {
  s := &SolverData{}
  s.hash = make(map[int]string)
  s.keys = make([]int, 0)
  s.salt = salt
  s.sf = sf
  return s
}

func Solve(salt string, sf int) int {
  s := NewSolver(salt, sf)

  index := 0
  for len(s.keys) < 64 {
    hash := s.GenHash(index)
    if s.isKey(hash, index) {
      s.keys = append(s.keys, index)
      // fmt.Printf("Key found at index=%d: %s\n", index, hash)
    }
    index++
  }
  return s.keys[63]
}

func (s *SolverData) isKey(hash string, index int) bool {
  c := foundTriple(hash)
  if c == 0 {
    return false
  }

  quint := string([]byte{c,c,c,c,c})
  for i := 1; i<= 1000; i++ {
    h2 := s.GenHash(index + i)
    if strings.Contains(h2, quint) {
      return true
    }
  }

  return false
}

func foundTriple(str string) byte {
  bytes := []byte(str)
  for i := 0; i < len(bytes)-2; i++ {
    if bytes[i] == bytes[i+1] && bytes[i] == bytes[i+2] {
      return bytes[i]
    }
  }
  return 0
}

func (s *SolverData) GenHash(index int) string {
  if hash, ok := s.hash[index]; ok {
    return hash
  }

  txt := fmt.Sprintf("%s%d", s.salt, index)
  hashBytes := md5.Sum([]byte(txt))
  hash := hex.EncodeToString(hashBytes[:])

  if s.sf > 0 {
    for si := 0; si < s.sf; si++ {
      hashBytes = md5.Sum([]byte(hash))
      hash = hex.EncodeToString(hashBytes[:])
    }
  }

  s.hash[index] = hash
  return hash
}