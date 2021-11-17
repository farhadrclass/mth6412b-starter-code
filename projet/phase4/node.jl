import Base.show

"""Type abstrait dont d'autres types de noeuds dériveront.
EN: Abstract type from which other node types will be derived.
"""
abstract type AbstractNode{T} end

"""Type représentant les noeuds d'un graphe.
EN: Type to representant the nodes of a graph

Exemple:

        noeud = Node("James", [π, exp(1)])
        noeud = Node("Kirk", "guitar")
        noeud = Node("Lars", 2)

"""
mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
  parent::Union{Node{T},Nothing} # the parent can be empty or some nodes 
  rank::Int # this is used to keep the level in the tree
  degree::Int # degree of a node
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

# it is assumed that all nodes derived from AbstractNode
# will have `name` and `data` fields.

"""Renvoie le nom du noeud.
EN: Return the name of the node
"""
name(node::AbstractNode) = node.name
"""
Return a degree of the node
"""
degree(node::AbstractNode) = node.degree
"""
Return a parent of the node
"""
parent(node::AbstractNode) = node.parent

"""
Return a rank of the node
"""
rank(node::AbstractNode) = node.rank

"""Renvoie les données contenues dans le noeud.
EN: Returns the data contained in the node """
data(node::AbstractNode) = node.data

"""Affiche un noeud.
EN: present the node 
"""
function show(node::AbstractNode)
  if (node.parent !== nothing) # if we have something to show
    println("Node ", name(node), ", data: ", data(node), ", Parent: ",parent(node), ", Rank: ",rank(node))
  else
    println("Node ", name(node), ", data: ", data(node))
  end
end

"""Setter for the parent"""
function setParent!(node::Node{T}, parentBuffer::Node{T}) where T
  node.parent = parentBuffer
  node
end
"""Setter for the rank"""
function setRank!(node::Node{T}, rankBuffer::Int) where T
  node.rank = rankBuffer
  node
end

"""Setter for the parent"""
function degree!(node::Node{T}, val::Int) where T
  node.degree += val
  node
end