""" 
Implementation of Rosenkrantz, Stearns, and Lewis algorithm
returns an upper bound to the optimal tour of the graph given.
returns an hamiltonian cycle, not necessarily the optimal one

It presupposes that the graph given is a complete graph.

"""
function rsl(graph::Graph{T,P}, root_vertex::Node{T}; is_kruskal = true) where {T,P}
    # Compute Minimal Spanning Tree of the graph:
    mst, mst_weight = is_kruskal ? kruskal(graph) : prim(graph)
    mst.root = name(root_vertex)
    mst_tree = Tree(mst)
    # execute depth-first-search on the tree:
    preorder = dfs(mst_tree)
    hamiltonian_cycle = Graph("hamiltonian_cycle", nodes(graph), Vector{Edge{P}}())
    # This step assumes that the graph is a complete graph.
    for i in 1:length(preorder) - 1
        current_node = preorder[i]
        next_node = preorder[i+1]
        edge_idx = findfirst(x -> any(y -> y == nodes(x), [(current_node, next_node), (next_node, current_node)]), edges(graph))
        add_edge!(hamiltonian_cycle, edges(graph)[edge_idx])
    end
    edge_idx = findfirst(x -> any(y -> y == nodes(x), [(preorder[1], preorder[end]), (preorder[end], preorder[1])]), edges(graph))
    add_edge!(hamiltonian_cycle, edges(graph)[edge_idx])
    
    return hamiltonian_cycle, total_weight(hamiltonian_cycle)
end