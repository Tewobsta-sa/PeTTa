% Graph Algorithms Library for PeTTa  
% Graph representation: graph(Name, Nodes, Edges)  
% Nodes: list of node identifiers (atoms)  
% Edges: list of edge(From, To, Weight) triples  
  
% Create a new empty graph with given name  
graph_create(Name, graph(Name, [], [])).  
  
% Add a node to the graph (prevents duplicates)  
graph_add_node(graph(Name, Nodes, Edges), Node, graph(Name, [Node|Nodes], Edges)) :-  
    \+ member(Node, Nodes).  
  
% Add an edge to the graph (validates nodes exist)  
graph_add_edge(graph(Name, Nodes, Edges), From, To, Weight, graph(Name, Nodes, [edge(From, To, Weight)|Edges])) :-  
    member(From, Nodes),  
    member(To, Nodes).  
  
% Breadth-first search to find path from Start to Goal  
graph_bfs(graph(_, _, Edges), Start, Goal, Path) :-  
    bfs([[Start]], Goal, Edges, RevPath),  
    reverse(RevPath, Path).  
  
bfs([[Goal|Path]|_], Goal, _, Path).  
bfs([Current|Rest], Goal, Edges, Path) :-  
    extend_path(Current, Edges, NewPaths),  
    append(Rest, NewPaths, NewQueue),  
    bfs(NewQueue, Goal, Edges, Path).  
  
extend_path([Node|Path], Edges, NewPaths) :-  
    findall([Next,Node|Path],   
            (member(edge(Node, Next, _), Edges), \+ member(Next, [Node|Path])),   
            NewPaths).  
  
% Depth-first search to find path from Start to Goal  
graph_dfs(graph(_, _, Edges), Start, Goal, Path) :-  
    dfs(Start, Goal, Edges, [Start], RevPath),  
    reverse(RevPath, Path).  
  
dfs(Current, Goal, _, Path, [Goal|Path]) :- Current = Goal.  
dfs(Current, Goal, Edges, Visited, Path) :-  
    member(edge(Current, Next, _), Edges),  
    \+ member(Next, Visited),  
    dfs(Next, Goal, Edges, [Next|Visited], Path).  
  
% Dijkstras algorithm for shortest path with cost  
graph_dijkstra(graph(_, _, Edges), Start, Goal, (Path, Cost)) :-  
    dijkstra(Edges, Start, Goal, [(0, [Start])], RevPath, Cost),  
    reverse(RevPath, Path).  
  
dijkstra(_, Goal, Goal, [(Cost, Path)|_], Path, Cost).  
dijkstra(Edges, Current, Goal, [(Cost, [Current|Path])|Rest], FinalPath, FinalCost) :-  
    findall((NewCost, [Next,Current|Path]),   
            (member(edge(Current, Next, Weight), Edges),  
             \+ member(Next, [Current|Path]),  
             NewCost is Cost + Weight),  
            NewPaths),  
    append(Rest, NewPaths, AllPaths),  
   keysort(AllPaths, [(_, [Next|_])|SortedRest]),
    dijkstra(Edges, Next, Goal, SortedRest, FinalPath, FinalCost).  
  
% Find connected components in the graph  
graph_connected_components(graph(_, Nodes, Edges), Components) :-  
    findall(Component, component(Nodes, Edges, [], Component), Components).  
  
component([], _, _, []).  
component([Node|Rest], Edges, Visited, [Node|Component]) :-  
    \+ member(Node, Visited),  
    reachable(Node, Edges, [Node], Reachable),  
    component(Rest, Edges, Reachable, Component).  
component([_|Rest], Edges, Visited, Component) :-  
    component(Rest, Edges, Visited, Component).  
  
reachable(Node, Edges, Visited, AllReachable) :-  
    findall(Next, (member(edge(Node, Next, _), Edges), \+ member(Next, Visited)), Direct),  
    append(Direct, Visited, NewVisited),  
    reachable_all(Direct, Edges, NewVisited, AllReachable).  
  
reachable_all([], _, Visited, Visited).  
reachable_all([Node|Rest], Edges, Visited, AllReachable) :-  
    reachable(Node, Edges, Visited, NewVisited),  
    reachable_all(Rest, Edges, NewVisited, AllReachable).  
  
% Check if graph is connected  
graph_is_connected(graph(_, Nodes, Edges), true) :-  
    Nodes \= [],  
    length(Nodes, N),  
    reachable_nodes(Nodes, Edges, Reachable),  
    length(Reachable, N).  
graph_is_connected(_, false).  
  
reachable_nodes([Node|_], Edges, Reachable) :-  
    reachable(Node, Edges, [Node], Reachable).  
  
% Get all neighbors of a node  
graph_neighbors(graph(_, _, Edges), Node, Neighbors) :-  
    findall(To, member(edge(Node, To, _), Edges), Neighbors).  
  
% Get degree of a node (number of connections)  
graph_degree(graph(_, _, Edges), Node, Degree) :-  
    findall(To, member(edge(Node, To, _), Edges), Neighbors),  
    length(Neighbors, Degree).  
  
% Check if two nodes are directly connected  
graph_are_connected(graph(_, _, Edges), Node1, Node2, true) :-  
    member(edge(Node1, Node2, _), Edges).  
graph_are_connected(graph(_, _, Edges), Node1, Node2, true) :-  
    member(edge(Node2, Node1, _), Edges).  
graph_are_connected(_, _, _, false).