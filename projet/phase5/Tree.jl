# # This code is for Tree data types in Julia
# # We will use it for RSL algorithm
# import Base.show

# abstract type AbstractTree{T} end

# """
# Tree Data type
# Exemple:

#         tree = Tree("myTree", [π, exp(1)],myOtherTree,[])
# """
# mutable struct Tree{T} <: AbstractTree{T}
#   name::String
#   data::T  # this is where nodes would go 
#   parent::Union{Tree{T},Nothing} # the parent can be empty or some Trees 
#   children::Vector{Tree{T}} # could be empty
# end

# """
# EN: Return the name of the Tree
# """
# name(Tree::AbstractTree) = Tree.name

# """
# Return a parent of the Tree
# """
# parent(Tree::AbstractTree) = Tree.parent

# """
# Return the children of the Tree
# """
# children(Tree::AbstractTree) = Tree.children

# """
# EN: Returns the data contained in the Tree """
# data(Tree::AbstractTree) = Tree.data

# """ 
# EN: present the Tree 
# """
# function show(Tree::AbstractTree)
#   if (Tree.parent !== nothing) # if we have something to show
#     println("Tree ", name(Tree), ", data: ", data(Tree), ", Parent: ",parent(Tree), ", children: ",children(Tree))
#   else
#     println("Tree ", name(Tree), ", data: ", data(Tree))
#   end
# end

# """Setter for the parent"""
# function setParent!(Tree::Tree{T}, parentBuffer::Tree{T}) where T
#   Tree.parent = parentBuffer
#   Tree
# end

# """Setter for the children"""
# function setchildren!(Tree::Tree{T}, children::Vector{Tree{T}}) where T
#   Tree.children = childrenBuffer
#   Tree
# end


# """Constructor for the Tree"""
# function Tree(myG::Graph{T},root::Node{T}) where {T}
#     #create a tree with only the root
#     myTree = Tree("myTree",root, nothing, Vector{Tree{T}}())
    
#     # copy the Nodes of the Graph
#     edgesBuffer =  copy(edges(myG))
#     treeBuffer = myTree
#     for edge in edgesBuffer
        
#         if edge.node1 == myTree.data || edge.node1 == myTree.data
    
#     end
#     return myTree
# end

# # we need a way of going through the tree, so I suggest we use DFS with recursive way
