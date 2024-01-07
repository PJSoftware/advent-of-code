// tsp solves the Travelling Salesman Problem
package tsp

// TSP is our Travelling Salesman Problem data structure
type TSP struct {
	nodes map[string]*node // key is node name
	paths map[string]*path // key is sorted node names joined with a '|' (ie, name1|name2)
}

type node struct {
	name string
}

type path struct {
	node1 *node
	node2 *node
	dist int
}

func NewTSP() *TSP {
	p := &TSP{}
	p.nodes = make(map[string]*node)
	p.paths = make(map[string]*path)
	return p
}

func (p *TSP) AddPath(name1, name2 string, dist int) {
	n1 := p.getNodeByName(name1)
	n2 := p.getNodeByName(name2)
	key := pathKey(name1, name2)
	if path, ok := p.paths[key]; ok {
		// redefine existing path if shorter distance found
		if path.dist > dist {
			path.dist = dist
		}
		return
	}

	path := &path{}
	if n1.name < n2.name {
		path.node1 = n1
		path.node2 = n2
	} else {
		path.node1 = n2
		path.node2 = n1
	}
	path.dist = dist
	p.paths[key] = path
}

func (p *TSP) ShortestTripFrom(start string, roundTrip bool) int {
	return p.BruteForceSolver(start, roundTrip)
}

func (p *TSP) getNodeByName(name string) *node {
	if node, ok := p.nodes[name]; ok {
		return node
	}

	node := &node{}
	node.name = name
	p.nodes[name] = node
	return node
}

func pathKey(n1, n2 string) string {
	if n1 < n2 {
		return n1 + "|" + n2
	}
	return n2 + "|" + n1
}
