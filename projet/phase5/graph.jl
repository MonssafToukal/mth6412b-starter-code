import Base.show
include(joinpath(@__DIR__, "read_stsp.jl"))

""" Abstract type where all the graphs will be derived from."""
abstract type AbstractGraph{T,P} end

"""Type representing a graph as a set of node.

Example :

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    node3 = Node("Jill", 4.12)
    edge = Edge(("Paris", "Pluton"), 100000.0)
    G = Graph("Ick", [node1, node2, node3], [edge])

All nodes must have the same datatype!
All edges must have the same datatype!
Nodes and edges don't need to have the same datatype

Ex:
    type of Node("Joe", 3.14) is Float64, type of Edge(('1', '1'), 2) is Int64
"""
mutable struct Graph{T, P} <: AbstractGraph{T,P}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{P}}
end

"""
Default outer constructor with no arguments 
Ex: graph = Graph{Vector{Int64}, Float64}()
"""
Graph{T,P}() where {T,P} = Graph("", Node{T}[], Edge{P}[])


"""Add a node to graph.

  optional parameter dim: represents the dimension of the graph,
  meaning the total number of nodes in the graph. its use is to create 
  arbitrary coordinates if the nodes don't have coordinates.
"""
function add_node!(graph::AbstractGraph{T,P}, node::Node{T}; dim = 1) where {T,P}

  if !isnothing(findfirst(x -> x.name == node.name, nodes(graph)))
    throw(NodeError("Node with that name already exists"))
  end

  if isempty(data(node))
    range_limit = 100 * dim
    node.data = [rand(1:range_limit), rand(1:range_limit)]
  end
  push!(graph.nodes, node)
  graph
end

"""Add edge to graph

  It will check if the edge is unique in the graph
  It will check if the nodes that are linked by the edge exist
"""
function add_edge!(graph::AbstractGraph{T,P}, edge::Edge{P}) where {T,P}

  #If one of the vertex is not in the graph we do not add the edge
  if isnothing(findfirst(x->x==edge.nodes[1],[nd.name for nd in graph.nodes])) || isnothing(findfirst(x->x==edge.nodes[2],[nd.name for nd in graph.nodes])) 
    throw(NodeError("trying to add edge when the node doesn't exist"))
  end
  #If the edge is already present we do not add it again
  #vetor of first vertex
  v1=[ed.nodes[1] for ed in graph.edges]
  #vector of second vertex
  v2=[ed.nodes[2] for ed in graph.edges]

  #We check the second vertex of all edge that have first vertex equal to the first vertex of the new edge and
  #we check the second vertex of all edge that have first vertex equal to the second vertex of the new edge
  if isnothing(findfirst(x->x==edge.nodes[2],v2[findall(x->x==edge.nodes[1],v1)])) || !isnothing(findfirst(x->x==edge.nodes[1],v2[findall(x->x==edge.nodes[2],v1)]))
    push!(graph.edges, edge)
  end
end

""" 
returns the total weight of a given graph
returns the sum of all the edges of the graph
"""

function total_weight(graph::Graph{T,P}) where {T,P}

  return sum(x -> x.value, edges(graph))  
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name` et `nodes`.

"""returns the name of the graph"""
name(graph::AbstractGraph) = graph.name

"""returns the list of nodes"""
nodes(graph::AbstractGraph) = graph.nodes

"""returns the list of edges"""
edges(graph::AbstractGraph) = graph.edges

"""returns the number of nodes in the graph"""
nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""prints a graph"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes.")
  for node in nodes(graph)
    show(node)
  end
  for edge in edges(graph)
    show(edge)
  end
end

"""This function builds a graph by reading the file"""
function build_graph(filename::String)
  try
    data_nodes, data_edges = read_stsp(filename)
    header = read_header(filename)
    graph = Graph{Vector{Float64},Float64}()

    # 1. Build Node Ojbects
    # Disclaimer: it generates random coords for the Nodes if there are no coords given in the file
    # two nodes might have the same coordinates even if it's unlikely
    for data_node in data_nodes
      data_dict = Dict(data_node.first => data_node.second)
      node = Node(data_dict)
      add_node!(graph, node; dim=length(data_nodes))
    end
  
    # 2. Build Edge Ojbects
    for data_edge in data_edges
      add_edge!(graph, Edge(("$(data_edge[1][1])", "$(data_edge[1][2])"), data_edge[2]))
    end

    return graph
  catch err
    println("Error encountered while building graph: ", err)
    return Graph{Vector{Float64},Float64}()
  end
end

""" Plots the graph by giving a graph object as an argument"""

function plot_graph(graph::AbstractGraph{T,P}) where {T,P}
  fig = plot(legend=false)
  
  for edge in graph.edges
    first_node = graph.nodes[findfirst(x -> x.name == edge.nodes[1], graph.nodes)]
    second_node = graph.nodes[findfirst(x -> x.name == edge.nodes[2], graph.nodes)]
    plot!([first_node.data[1], second_node.data[1]], [first_node.data[2], second_node.data[2]], 
          linewidth=1.5, alpha=0.75, color=:turquoise)
  end
  
  # node positions
  xys = [data(node) for node in graph.nodes]

  x = [xy[1] for xy in xys]
  y = [xy[2] for xy in xys]
  scatter!(x, y)

  fig
  return fig

end
