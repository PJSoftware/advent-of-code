package graph_test

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/pjsoftware/advent-of-code/2016/lib/graph"
)

func TestNewGraph(t *testing.T) {
	g := graph.NewGraph()
	exp := "*graph.Graph"
	got := fmt.Sprintf("%v", reflect.TypeOf(g))
	if got != exp {
		t.Errorf("g (type '%s') is not '%s", got, exp)
	}
}