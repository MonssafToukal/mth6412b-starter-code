""" Prim Algortihm
    
takes a Graph{T,P} as an argument

returns mininmal spanning tree of the graph by adding nodes into the current solution
"""
function prim(graph::Graph{T,P}) where {T,P}

    graph_nodes = Dict(name(node) => node for node in nodes(graph))

    # By default the random node is the first one in the list of nodes
    random_node = nodes(graph)[1]
    # initial connected component. We will add nodes to it iteratively
    minimal_spanning_tree = ConnectedComponent(name(random_node), [random_node], Vector{Edge{P}}(), 0)
    # ordering the edges so that it will be easier to find the smallest useful edge
    ordered_edges = sort(edges(graph), by=value, rev=false)

    while length(nodes(minimal_spanning_tree)) != length(nodes(graph))
        # getting the names of the nodes in the current solution
        node_names = [name(connected_node) for connected_node in nodes(minimal_spanning_tree)]
        # getting the smallest useful edge from the available edge
        contains_node, edge = find_edges(node_names, ordered_edges) 
        # Figuring out which node to add to the current solution
        if contains_node[1]
            add_node!(minimal_spanning_tree, graph_nodes[nodes(edge)[1]])
        elseif contains_node[2]
            add_node!(minimal_spanning_tree, graph_nodes[nodes(edge)[2]])
        end
        add_edge!(minimal_spanning_tree, edge)
    end

    return  minimal_spanning_tree, total_weight(minimal_spanning_tree)

end

""" 
Finds the smallest edge that connects the known connected component to another node not in the current solution.

It returns a tuple/vector of two boolean values that tell us if the first and the second node of the edge respectively are already in the current solution 
    
"""
function find_edges(node_names::Vector{String}, ordered_edges::Vector{Edge{P}}) where P

    for edge in ordered_edges
        contains_node = (isnothing(findfirst(x-> x == edge.nodes[1], node_names)), isnothing(findfirst(x-> x == edge.nodes[2], node_names)))
        if contains_node[1] != contains_node[2]
            return contains_node, edge
        end
    end
end

