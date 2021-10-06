import Base.show
# include("node.jl")

""" Abstract type from which other edge types will be derived.
"""
# abstract type AbstractEdge end

"""Type to representant the Edges of a graph

Exemple:

    #Old  edge1 = Edge("TO-MTL",(1,2), 100 )
    #edge1= Edge((1,2), 100 ) 
    edge1= Edge(node1, node2, 50.1)

 TODO I will try to break the edge to edgeNode1 , edgeNode2 later to make the reading them faster

"""
mutable struct Edge 
  # node1::Node{K} # Start node 
  node1::AbstractNode #
  # node2::Node{K} # Finish node
  node2::AbstractNode #
  weight::Float64
end



edgeStart(edge) = name(edge.node1)

edgeEnd(edge) = name(edge.node2)

"""Renvoie les données contenues dans le noeud.
EN: Returns the weight contained in the edge """
weight(edge) = edge.weight

"""Affiche un noeud.
EN: present the edge 
"""
# Fix this later
function show(edge)
  println("Starting Point ",edgeStart(edge) ,", EndNode ", edgeEnd(edge), ", weight: ", weight(edge))
end
