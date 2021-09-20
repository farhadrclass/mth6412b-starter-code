import Base.show

"""Type abstrait dont d'autres types de graphes dériveront.
EN: Abstract type from which other types of graphs will be derived.
"""
abstract type AbstractGraph{T} end

"""Type representant un graphe comme un ensemble de noeuds.
En: Type representing a graph as a set of nodes.

Exemple :

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    node3 = Node("Jill", 4.12)
    G = Graph("Ick", [node1, node2, node3])

Attention, tous les noeuds doivent avoir des données de même type.
EN: Attention, all nodes must have data of the same type.
"""
mutable struct Graph{T} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
  # weight::Vector{Edge{T}}  # Added the place holder for
end

"""Ajoute un noeud au graphe.
EN: This Function adds a note to the graph
"""
function add_node!(graph::Graph{T}, node::Node{T}) where T
  push!(graph.nodes, node)
  graph
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name` et `nodes`.

# it is assumed that all graphs derived from AbstractGraph
# will have `name` and `nodes` fields.



"""Renvoie le nom du graphe.
EN: Returns the name of the graph
"""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe.
EN: Retuens a list of nodes of the graph
"""
nodes(graph::AbstractGraph) = graph.nodes

"""Renvoie le nombre de noeuds du graphe.
EN: Returns a size or number of nodes of a graph
"""
nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Affiche un graphe
EN: Display a graph
"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes.")
  for node in nodes(graph)
    show(node)
  end
end
