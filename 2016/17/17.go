package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"regexp"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type Location struct {
	X        int
	Y        int
	Path     string
	Unlocked []string
}

type Dir struct {
	X int
	Y int
}

var Direction = make(map[string]*Dir)

func init() {
	Direction["U"] = &Dir{X: 0, Y: -1}
	Direction["D"] = &Dir{X: 0, Y: 1}
	Direction["L"] = &Dir{X: -1, Y: 0}
	Direction["R"] = &Dir{X: 1, Y: 0}
}

// PASSCODE is globally set via Solve(); not an ideal solution, but it will do for our purposes
var PASSCODE string

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")

	testData := map[string]string{
		"ihgpwlah": "DDRRRD",
		"kglvqrro": "DDUDRLRRUDRD",
		"ulqzkmiv": "DRURDRUDDLLDLUURRDULRLDUUDDDRR",
	}
	test2Data := map[string]int{
		"ihgpwlah": 370,
		"kglvqrro": 492,
		"ulqzkmiv": 830,
	}
	for testPass, testAnswer := range testData {
		advent.Test(fmt.Sprintf("shortest calculation (%s)", testPass), testAnswer, Solve(testPass, false))
		advent.Test(fmt.Sprintf("longest calculation (%s)", testPass), test2Data[testPass], len(Solve(testPass, true)))
	}
	advent.BailOnFail()

	fmt.Print("All tests passed!\n\n")

	// Solution

	passCode := advent.InputString("17")
	fmt.Printf("Solution -- shortest: %s\n", Solve(passCode, false))
	fmt.Printf("Solution -- longest: %d\n", len(Solve(passCode, true)))
}

// Solution code

func NewLocation(x, y int, path string) *Location {
	l := &Location{}
	l.X = x
	l.Y = y
	l.Path = path
	l.md5Unlock()
	return l
}

func Solve(passcode string, findLongest bool) string {
	PASSCODE = passcode
	start := NewLocation(1, 1, "")
	vault := NewLocation(4, 4, "?")

	longestLength := 0
	longestPath := ""

	possibleLocations := []*Location{start}
	step := 0
	for {
		step++
		newLocations := []*Location{}

		if len(possibleLocations) == 0 {
			return longestPath
		}

		for _, currLoc := range possibleLocations {
			for _, dirName := range currLoc.Unlocked {
				dir := Direction[dirName]
				x := currLoc.X + dir.X
				y := currLoc.Y + dir.Y
				p := currLoc.Path + dirName

				if x == vault.X && y == vault.Y {
					if !findLongest {
						return p
					}
					if longestLength < len(p) {
						longestLength = len(p)
						longestPath = p
					}

				} else if validRoom(x, y) {
					loc := NewLocation(x, y, currLoc.Path+dirName)

					if len(loc.Unlocked) > 0 {
						newLocations = append(newLocations, loc)
					}
				}
			}
		}

		possibleLocations = []*Location{}
		possibleLocations = append(possibleLocations, newLocations...)
	}
}

// {*Location}.md5Unlock() takes the passcode and current path, and generates a
// list of unlocked doors for the current location
func (l *Location) md5Unlock() {
	l.Unlocked = make([]string, 0, 4)

	key := PASSCODE + l.Path
	hashBytes := md5.Sum([]byte(key))
	hash := hex.EncodeToString(hashBytes[:])

	unlocked := regexp.MustCompile("[bcdef]")

	dirs := []string{"U", "D", "L", "R"}
	for i, dirName := range dirs {
		dirKey := hash[i : i+1]
		if unlocked.MatchString(dirKey) {
			dir := Direction[dirName]
			if validRoom(l.X+dir.X, l.Y+dir.Y) {
				l.Unlocked = append(l.Unlocked, dirName)
			}
		}
	}
}

// validRoom() determines whether the specified x,y coordinates represent a
// valid room
func validRoom(x, y int) bool {
	return x >= 1 && x <= 4 && y >= 1 && y <= 4
}
