import Base.show
""" Abstrct type where all the Edges will be derived from"""
abstract type AbstractEdge{P} end


# In the future, this edge will have to implement directionality
"""
Type Edge derivedfrom Abstract Edge 

Example: 
        edge = Edge(("Paris", "Pluton"), 100000.0)   
"""
mutable struct Edge{P} <: AbstractEdge{P}
    nodes::Tuple{String, String}
    value::P
end

nodes(edge::AbstractEdge) = edge.nodes
value(edge::AbstractEdge) = edge.value


"""prints edge information"""
function show(edge::AbstractEdge)
  println("Edge nodes: ", nodes(edge), ", value: ", value(edge))
end