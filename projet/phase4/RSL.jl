# first find the MST
# create a tree  then dfs the tree or just find the ordered list of the nodes
# pree order the nodes
# add the edges between them 
# return 
# Import the other files    
include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

include("kruskal.jl")
include("prim.jl")

"""This function gets the root and return the ordered list of nodes after the MST has been found 
another way is to create a tree to do the same thing 
"""
function inOrder(root::Node{T}, myG::Graph{T}, orderedNodes:: Vector{Node{T}}=Node{T}[]) where T
    
    if !(root in orderedNodes) 
        push!(orderedNodes, root)
    end

    for node in nodes(myG)
        if !(node in orderedNodes) # if we already visited this then ignore, 
            # find all edges that have node as one of the nodes 
            selectEdges = edges(myG)[findall(x -> x.node1 == node || x.node2== node , edges(myG))]
            if(length(selectEdges)>1)
                for edge in selectEdges
                    inOrder(node, myG,orderedNodes) #recursivecall
                end
            end  
        end  
    end
    return orderedNodes
end


"""
if algo == 1 it uses Prim otherwise uses Kruskal algo 
"""
function RSL(algo::Int64, root::Node{T}, myG::Graph{T}) where T

    if algo == 1
        MST = PrimMST(myG)
    else
        MST = KruskalMST(myG)
    end 
    # pre order the nodes
    preOrder = inOrder(root, MST)
    myCycle = Graph("Hamiltonian Cycle",nodes(myG),Edge[])
    for i in 1:length(preOrder) - 1
        current= preOrder[i]
        next = preOrder[i+1]
        idx = findfirst(x -> ((x.node1 == current && x.node2 == next) || (x.node1 == next && x.node2 == current)) , edges(myG)) # find where current and next node are 
        # print(idx,"\n")
        add_edge!(myCycle, edges(myG)[idx])
    end
    return weightGraph(myCycle),myCycle # returning the total weight and the cycle 
end
