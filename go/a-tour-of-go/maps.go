package main

import "fmt"

type Vertex struct {
	Lat, Long float64
}

// var m map[string]Vertex
var m = map[string]Vertex{
	"Bell Labs": Vertex{
		40.68433, -74.39967,
	},
	"Google": Vertex{
		37.42202, -122.08408,
	},
}

var n = map[string]Vertex{
	"Bell Labs": Vertex{40.68433, -74.39967},
	"Google":    Vertex{37.42202, -122.08408},
}

func main() {
	fmt.Println(m)
	m = make(map[string]Vertex)
	m["Bell"] = Vertex{
		40.68433,
		-74.39967,
	}

	fmt.Println(m["Bell"])
	fmt.Println(n)
}
