import Base.show

"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T,P} end

"""Type representant un graphe comme un ensemble de noeuds.

Exemple :

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    node3 = Node("Jill", 4.12)
    G = Graph("Ick", [node1, node2, node3])

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Graph{T, P} <: AbstractGraph{T,P}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{T,P}}
end

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T,P}, node::Node{T}) where {T,P}
  push!(graph.nodes, node)
  graph
end

"""Ajoute une arêtes au graphe."""
function add_edge!(graph::Graph{T,P}, edge::Edge{T,P}) where {T,P}
  # TODO: make sure that the edge obj is well constructed and that the edge is unique in the graph
  push!(graph.edges, edge)
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name` et `nodes`.

"""Renvoie le nom du graphe."""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
nodes(graph::AbstractGraph) = graph.nodes

"""Renvoie la liste des arêtes du graphe."""
edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes.")
  for node in nodes(graph)
    show(node)
  end
  for edge in edges(graph)
    show(edge)
  end
end
