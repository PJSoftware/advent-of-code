package main

import (
	"fmt"
	"log"
	"math"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
	"github.com/pjsoftware/advent-of-code/2016/lib/graph"
)

type DijkstraData struct {
  Distance int
  Visited bool
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
  advent.Test("testMaze", 14, Solve(testMaze, false))
  advent.Test("testMaze", 20, Solve(testMaze, true))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  maze := advent.InputStrings("24")
  fmt.Printf("Solution 1: %d\n",Solve(maze, false))
  fmt.Printf("Solution 2: %d\n",Solve(maze, true))
}

// Solution code

// First we read our maze as a slice of strings. This is then converted to a
// grid of cells -- and we can create a node for each named cell. We can then
// use the Dijkstra algorithm with our grid -- once for each named cell -- to
// find the shortest path to each other named cell, and create links with that
// distance between each node. Finally, we can then apply the TSP algorithm to
// our network of nodes and links, to find the shortest path through every node.

func Solve(maze []string, loop bool) int {
  g1 := ConvertToGraph(maze)
  g2 := graph.NewGraph()

  names := g1.Names()
  for _, name := range names {
    g2.AddIdentifiedNode("", name, math.MaxInt)
  }

  seen := make(map[string]bool)
  for  _, source := range names {
    seen[source] = true
    src, _ := g1.NodeByName(source)
    FindShortestDistancesFrom(g1, src)

    for _, target := range names {
      if seen[target] { continue }
      tgt, _ := g1.NodeByName(target)
      tv := nodeValue(g1, tgt)
      // fmt.Printf("Distance from %s to %s: %d\n", source, target, tv.Distance)
      g2.AddPathBetween(source, target, tv.Distance)
    }
  }

  return ShortestPath(g2, "0", loop)
}

var shortestPathLength int

func ShortestPath(g *graph.Graph, startNodeName string, loop bool) int {
  namesRandom := g.Names()
  start := "0"
  names := []string{}
  for _, name := range namesRandom {
    if name != start {
      names = append(names, name)
    }
  }
  shortestPathLength = math.MaxInt
  shortestPermutation(g, start, names, len(names), loop)
  return shortestPathLength
}

// Heap's algorithm for generating permutations
func shortestPermutation(g *graph.Graph, start string, names []string, size int, loop bool) {
	if size == 1 {
    dist := calculateLength(g, start, names, loop)
		// fmt.Printf("0 -> %v (%d)\n", names, dist)
    if dist < shortestPathLength {
      shortestPathLength = dist
    }
	}

	for i := 0; i < size; i++ {
		shortestPermutation(g, start, names, size-1, loop)

		if size%2 == 1 {
			names[0], names[size-1] = names[size-1], names[0]
		} else {
			names[i], names[size-1] = names[size-1], names[i]
		}
	}
}

func calculateLength(g *graph.Graph, start string, names []string, loop bool) int {
  dist := 0
  n1 := start
  path := []string{}
  path = append(path, names...)
  if loop {
    path = append(path, start)
  }

  for _, n2 := range path {
    length, err := g.PathLength(n1, n2)
    if err != nil {
      log.Fatalf("no path length: %v", err)
    }
    dist += length
    n1 = n2
  }
  return dist
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
      dv := &DijkstraData{Distance: math.MaxInt, Visited: false}
      g.AddIdentifiedNode(key,name, *dv)
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

// FindShortestDistancesFrom() implements Dijkstra's Algorithm to generate a
// Shortest Path Tree, calculating the shortest paths to all nodes from the
// specified starting node. It is called once for each named node, allowing us
// to construct a new graph consisting only of the named nodes and the distances
// between them!
func FindShortestDistancesFrom(g *graph.Graph, index int) {
  resetNodeValues(g, math.MaxInt, false)
  setNodeValue(g, index, 0, false)

  for {
    currentNode, err := getNextNode(g)
    if err != nil { return }

    cv := nodeValue(g, currentNode)
    setNodeValue(g, currentNode, cv.Distance, true)
    neighbours := g.Neighbours(currentNode)
    for _, neighbour := range neighbours {
      pathLength, err := g.PathLength(currentNode, neighbour)
      if err != nil {
        log.Fatalf("path between nodes %d and %d not found: %v", currentNode, neighbour, err)
      }
      nv := nodeValue(g, neighbour)
      dist := cv.Distance + pathLength
      if !nv.Visited && nv.Distance > dist {
        setNodeValue(g, neighbour, dist, false)
      }
    }
  }
}

func nodeValue(g *graph.Graph, index int) DijkstraData {
  var xv DijkstraData
  var ok bool
  x := g.NodeValue(index)
  if xv, ok = x.(DijkstraData); !ok {
    log.Fatalf("DijkstraData identifier expected from NodeValue(); '%v' is a %T", x, x)
  }
  return xv
}

func resetNodeValues(g *graph.Graph, distance int, visited bool) {
  dv := &DijkstraData{Distance: distance, Visited: visited}
  g.SetAllNodeValues(*dv)
}

func setNodeValue(g *graph.Graph, index int, distance int, visited bool) {
  dv := &DijkstraData{Distance: distance, Visited: visited}
  g.SetNodeValue(index, *dv)
}

func getNextNode(g *graph.Graph) (int, error) {
  allNodes := g.Nodes()
  found := false
  dist := math.MaxInt
  var rv int
  for _, node := range allNodes {
    nv := nodeValue(g, node)
    if nv.Visited { continue }
    if nv.Distance < dist {
      rv = node
      found = true
      dist = nv.Distance
    }
  }
  if found {
    return rv, nil
  }
  return -1, fmt.Errorf("all nodes have been visited")
}
