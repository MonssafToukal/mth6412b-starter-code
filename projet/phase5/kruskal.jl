""" Kruskal Algortihm
    
takes a Graph{T,P} as an argument

returns mininmal spanning tree of the graph
"""
function kruskal(graph::Graph{T,P}) where {T,P}
    # 1. collect all nodes as connected components
    connected_components = Dict(comp.root => comp for comp in [ConnectedComponent(name(node), [node], Vector{Edge{P}}(), 0) for node in nodes(graph)])

    # 2. Order the edges by weight (biggest to smallest)
    ordered_edges = sort(edges(graph), by=value, rev=true)

    # 3. adding iteratively edges
    while(length(connected_components) > 1)
        smallest_edge = pop!(ordered_edges)
        # finding components linked by the smallest edges in the original graph, but not yet connected in the MST
        first_component, second_component = get_components(nodes(smallest_edge), connected_components)
        if first_component.root != second_component.root
            merged_component, root_to_delete = merge_components!(first_component, second_component, smallest_edge)
            connected_components[merged_component.root] = merged_component
            delete!(connected_components, root_to_delete)
        end
    end
    minimal_spanning_tree = collect(values(connected_components))[1]
    
    return minimal_spanning_tree, total_weight(minimal_spanning_tree)
end

""" returns the components connected by the nodes given as arguments """
function get_components(node_names::Tuple{String, String}, connected_components::Dict{String, ConnectedComponent{T,P}}) where {T,P}

    components = Vector{ConnectedComponent{T,P}}()
    for connected_component in connected_components
        for node in nodes(connected_component[2])
            if name(node) in node_names
                push!(components, connected_component[2])
            end
            if length(components) == 2

                return Tuple(components)
            end
        end
end
throw(error("the nodes aren't in any connected component"))
end
