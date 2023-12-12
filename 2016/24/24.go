package main

import (
	"fmt"
	"math"
	"os"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

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

type Grid struct {
  grid [][]*Cell // this is actually, counter-intuitively, [y][x]byte
  dy, dx int
  nodes []*Node
}

type Cell struct {
  value byte
  dist int
}

type Node struct {
  value string
  x, y int
  dist int
  links []*Link
}

type Link struct {
  node1 *Node
  node2 *Node
  dist int
}

func Solve(maze []string) int {
  grid := ConvertToGrid(maze)
  _ = grid
  return 0
}

func ConvertToGrid(maze []string) *Grid {
  g := &Grid{}
  g.dy = len(maze)
  g.dx = len(maze[0])

  g.grid = make([][]*Cell, g.dy)
  for i := range g.grid {
    g.grid[i] = make([]*Cell, g.dx)
    bfr := []byte(maze[i])
    for j := range bfr {
      cell := &Cell{}
      cell.dist = math.MaxInt
      cell.value = bfr[j]
      g.grid[i][j] = cell
    }
  }

  g.nodes = make([]*Node, 0)
  for y := 0; y < g.dy; y++ {
    for x := 0; x < g.dx; x++ {
      if g.grid[y][x].value == '#' || g.grid[y][x].value == '.' {
        continue
      }
      node := &Node{}
      node.value = string(g.grid[y][x].value)
      node.dist = math.MaxInt
      if node.value == "0" {
        node.dist = 0
      }
      g.nodes = append(g.nodes, node)
    }
  }
  return g
}
