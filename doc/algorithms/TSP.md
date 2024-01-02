# Travelling Salesman Problem

Given a graph of nodes, find the shortest path that visits all nodes.

I initially implemented [this algorithm](https://www.tutorialspoint.com/design_and_analysis_of_algorithms/design_and_analysis_of_algorithms_travelling_salesman_problem.htm#:~:text=as%20the%20output.-,Algorithm,distance%20to%20the%20largest%20distance), but it is only an approximation; the path it finds may not be (and indeed, was not) the shortest path.

I then took the brute force approach, using [Heap's Algorithm](https://gist.github.com/thisiscetin/20874a3c59e9fdfb4e184cac4130944d) to generate all possible permutations of nodes starting with "0", and calculated the length of each path, returning the shortest length found.
