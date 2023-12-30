package main

import (
	"fmt"
	"math"
	"os"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
	"github.com/pjsoftware/advent-of-code/2016/lib/graph"
)

type Dir struct {
	X,Y int
}

var Directions = []*Dir{
	{0,1},	// Up
	{0,-1},	// Down
	{-1,0},	// Left
	{1,0},	// Right
}

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")

  testMaze := []string{
    "###########",
    "#0.1.....2#",
    "#.#######.#",
    "#4.......3#",
    "###########",
  }
  advent.Test("testMaze", 14, Solve(testMaze))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  os.Exit(1)

  // Solution
  
  maze := advent.InputStrings("24")
  fmt.Printf("Solution: %d\n",Solve(maze))
}

// Solution code

// First we read our maze as a slice of strings. This is then converted to a
// grid of cells -- and we can create a node for each named cell. We can then
// use the Dijkstra algorithm with our grid -- once for each named cell -- to
// find the shortest path to each other named cell, and create links with that
// distance between each node. Finally, we can then apply the Dijkstra algorithm
// once more to our network of nodes and links, to find the shortest path
// through every node.

func Solve(maze []string) int {
  _ = ConvertToGraph(maze)
  // names := g.Names()
  return 0
}

func ConvertToGraph(maze []string) *graph.Graph {
  g := graph.NewGraph()

  var minX, minY, maxX, maxY int
  minX = math.MaxInt
  minY = math.MaxInt
  maxX = 0
  maxY = 0
  for y, row  := range maze {
    rowBfr := []byte(row)
    for x, cell := range rowBfr {
      if cell == '#' {
        continue
      }

      if x < minX { minX = x }
      if x > maxX { maxX = x }
      if y < minY { minY = y }
      if y > maxY { maxY = y }
      key := generateKey(x,y)
      var name string
      if cell == '.' {
        name = ""
      } else {
        name = string(cell)
      }
      fmt.Printf("%s: %s\n", name, key)
      g.AddIdentifiedNode(key,name,math.MaxInt)
    }
  }

  for x := minX; x <= maxX; x++ {
    for y := minY; y <= maxY; y++ {
      src := generateKey(x,y)
      pRight := generateKey(x+1,y)
      pDown := generateKey(x,y+1)
      g.AddPathBetween(src, pRight, 1)
      g.AddPathBetween(src, pDown, 1)
    }
  }
  return g
}

func generateKey(x, y int) string {
  return fmt.Sprintf("(%d,%d)", x, y)
}