; Graph Algorithms Library for PeTTa  
; Prolog-backed implementation providing graph operations  
  
; Import the Prolog interop helpers from lib_zar  
!(import! &self (library lib_zar.metta))  
  
; Import Prolog functions from lib_graph.pl  
!(import_prolog_functions_from_file_pred (library lib_graph.pl) (graph_create graph_add_node graph_add_edge graph_bfs graph_dfs graph_dijkstra graph_connected_components graph_is_connected graph_neighbors graph_degree graph_are_connected))  
  
; Type definitions for all graph functions  
(: graph_create (-> Atom Atom))  
(: graph_add_node (-> Atom Atom Atom))  
(: graph_add_edge (-> Atom Atom Atom Number Atom))  
(: graph_bfs (-> Atom Atom Atom Atom))  
(: graph_dfs (-> Atom Atom Atom Atom))  
(: graph_dijkstra (-> Atom Atom Atom Atom))  
(: graph_connected_components (-> Atom Atom))  
(: graph_is_connected (-> Atom Atom Bool))  
(: graph_neighbors (-> Atom Atom Atom))  
(: graph_degree (-> Atom Atom Number))  
(: graph_are_connected (-> Atom Atom Atom Bool))  
  
; Wrapper functions for graph operations  
  
; Create a new empty graph  
(= (graph-create $name)  
   (callPredicate (Predicate (quote (graph_create $name $graph)))))  
  
; Add a node to an existing graph  
(= (graph-add-node $graph $node)  
   (callPredicate (Predicate (quote (graph_add_node $graph $node $newgraph)))))  
  
; Add a weighted edge to an existing graph  
(= (graph-add-edge $graph $from $to $weight)  
   (callPredicate (Predicate (quote (graph_add_edge $graph $from $to $weight $newgraph)))))  
  
; Find path using Breadth-First Search  
(= (graph-bfs $graph $start $goal)  
   (callPredicate (Predicate (quote (graph_bfs $graph $start $goal $path)))))  
  
; Find path using Depth-First Search  
(= (graph-dfs $graph $start $goal)  
   (callPredicate (Predicate (quote (graph_dfs $graph $start $goal $path)))))  
  
; Find shortest path using Dijkstra's algorithm (returns (path, cost))  
(= (graph-dijkstra $graph $start $goal)  
   (callPredicate (Predicate (quote (graph_dijkstra $graph $start $goal $result)))))  
  
; Find all connected components in the graph  
(= (graph-connected-components $graph)  
   (callPredicate (Predicate (quote (graph_connected_components $graph $components)))))  
  
; Check if the graph is connected  
(= (graph-is-connected $graph)  
   (callPredicate (Predicate (quote (graph_is_connected $graph $result)))))  
  
; Get all neighbors of a node  
(= (graph-neighbors $graph $node)  
   (callPredicate (Predicate (quote (graph_neighbors $graph $node $neighbors)))))  
  
; Get the degree (number of connections) of a node  
(= (graph-degree $graph $node)  
   (callPredicate (Predicate (quote (graph_degree $graph $node $degree)))))  
  
; Check if two nodes are directly connected  
(= (graph-are-connected $graph $node1 $node2)  
   (callPredicate (Predicate (quote (graph_are_connected $graph $node1 $node2 $result)))))