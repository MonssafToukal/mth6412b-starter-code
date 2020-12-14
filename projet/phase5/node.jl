import Base.show

"""Abstract type where Node{T} is derived from"""
abstract type AbstractNode{T} end

"""Datatype for the node of an arbitrary graph.

Example:

        node = Node("James", [π, exp(1)])
        node = Node("Kirk", "guitar")
        node = Node("Lars", 2)
"""
mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
end

"""Constructs a node by giving a dictionary of specific type as an argument"""
function Node(dict::Dict{Int64, Vector{Float64}})  
  if length(dict) != 1
    throw(NodeError("invalid dictionary given to build Node"))
  end
  name = ""
  data = Float64[]
  for elem in dict
    name = "$(elem[1])"
    data = elem[2]
  end
  return Node(name, data) 
end

"""returns the name of a node"""
name(node::AbstractNode) = node.name

"""returns the data of a node"""
data(node::AbstractNode) = node.data



"""prints node information"""
function show(node::AbstractNode)
  println("Node ", name(node), ", data: ", data(node))
end
