package main

import (
	"fmt"
	"regexp"
	"strconv"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type room struct {
  encName string
  decName string
  sectorID int
  checksum string
  isValid bool
}

func main() {
  // Tests

  fmt.Printf("Running tests:\n\n")

  testRooms := map[string]bool {
    "aaaaa-bbb-z-y-x-123[abxyz]": true,
    "a-b-c-d-e-f-g-h-987[abcde]": true,
    "not-a-real-room-404[oarel]": true,
    "totally-real-room-200[decoy]": false,
  }

  var testRoomList []room 
  for testData, testValidity := range(testRooms) {
    testRoom := newRoom(testData)
    testRoomList = append(testRoomList, *testRoom)
    advent.Test(testData, testValidity, testRoom.isValid)
  }
  advent.Test("checksum","oarel",genRoomChecksum("not-a-real-room-404[oarel]"))
  advent.Test("sector id total", 1514, sectorSum(testRoomList))
  advent.Test("decryption", "very encrypted name", decrypt("qzmt-zixmtkozy-ivhz",343))

  advent.BailOnFail()

  fmt.Printf("All tests passed!\n\n")

  // Solution
  
  var roomList []room 
  input := advent.InputStrings("04")
  np, _ := regexp.Compile(`north.*pole`)
  for _, roomData := range(input) {
    room := newRoom(roomData)
    roomList = append(roomList, *room)
    if room.isValid {
      if np.MatchString(room.decName) {
        fmt.Printf("Room %s -> %s\n",roomData,room.decName)
      }
    }
  }
  fmt.Printf("Solution: %d\n",sectorSum(roomList))
}

// Solution code

func newRoom(data string) *room {
  rm := &room{}

  re := regexp.MustCompile(`(.+)-(\d+)\[(.{5})\]`)
  match := re.FindStringSubmatch(data)
  rm.encName = match[1]
  
  id, _ := strconv.Atoi(match[2])
  rm.sectorID = id

  rm.checksum = match[3]
  rm.testValidity()
  if rm.isValid {
    rm.decName = decrypt(rm.encName, rm.sectorID)
  }

  return rm
}

func (rm *room) testValidity() {
  cs := genRoomChecksum(rm.encName)
  rm.isValid = (cs == rm.checksum)
}

func genRoomChecksum(roomName string) string {
  runeFrequency := countRuneFrequency(roomName)
  cs := ""
  for len(cs) < 5 {
    mostUsedFreq := 0
    
    for r := 'a'; r <= 'z'; r++ {
      // fmt.Printf("[%c]",r)
      if runeFrequency[r] > mostUsedFreq {
        mostUsedFreq = runeFrequency[r]
      }
    }
    for r := 'a'; r <= 'z'; r++ {
      if runeFrequency[r] == mostUsedFreq {
        if len(cs) < 5 {
          cs += string(r)
          runeFrequency[r] = 0
        }
      }
    }

  }
  
  return cs
}

func countRuneFrequency(roomName string) map[rune]int {
  freq := map[rune]int{}
  for r := 'a'; r <= 'z'; r++ {
    freq[r] = 0
  }

  for _, ch := range(roomName) {
    if ch != '-' {
      freq[ch]++
    }
  }
  return freq
}

func sectorSum(rooms []room) int {
  sum := 0
  for _, rm := range(rooms) {
    if rm.isValid {
      sum += rm.sectorID
    }
  }
  return sum
}

func decrypt(encName string, sectorID int) string {
  decName := ""

  for _, r := range(encName) {
    if r == '-' {
      decName += " "
    } else {
      for i := 0; i < sectorID; i++ {
        if r == 'z' {
          r = 'a'
        } else {
          r++
        }
      }
      decName += string(r)
    }
  }
  return decName
}