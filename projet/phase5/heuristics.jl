
""" Merges two connected components into one. 
Takes two components
returns a merged component of the two given as arguments 

First Heuristic: Merge Disjoint sets using the rank
"""
function merge_components!(first_component::ConnectedComponent{T,P}, second_component::ConnectedComponent{T,P}, edge_link::Edge{P}) where {T,P}

    root_to_delete = root(second_component)
    # comparing ranks between two components (their respective root)
    if rank(first_component) == rank(second_component)
        first_component.rank += 1
    elseif rank(first_component) < rank(second_component)
        root_to_delete = root(first_component)
        first_component.root = second_component.root
        first_component.rank = second_component.rank
    end
    # we transfer the nodes from one component to the other to complete the merge
    for node in nodes(second_component)
        add_node!(first_component, node)
    end
    # we transfer the edges from one component to the other to complete the merge
    for edge in edges(second_component)
        add_edge!(first_component, edge)
    end
    # adding the edge given as argument
    add_edge!(first_component, edge_link)
    second_component = nothing
    
    return first_component, root_to_delete
end