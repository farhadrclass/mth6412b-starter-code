# first find the MST
# create a tree  then dfs the tree or just find the ordered list of the nodes
# pree order the nodes
# add the edges between them 
# return 


"""This function gets the root and return the ordered list of nodes after the MST has been found 
another way is to create a tree to do the same thing 
"""
function inOrder(root::Node{T}, myG::Graph{T}, orderedNodes:: Vector{Node{T}}=Node{T}[]) where T
    push!(orderedNodes, root)
    for node in nodes(myG)
        if !(node in orderedNodes) # if we already visited this then ignore, 
            # find all edges that have node as one of the nodes 
            edges=findall(x -> x.node1 == node || x.node2== node , edges(myG))
            for edge in edges
                inOrder(node, myG,orderedNodes) #recursivecall
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
    for i in 1:length(preorder) - 1
        current= preOrder[i]
        next = preOrder[i+1]
        idx = findfirst(x -> ((x.node1 == current && x.node2 == next) || (x.node1 == next && x.node2 == current)) , edges(myG)) # find where current and next node are 
        add_edge!(myCycle, edges(graph)[idx])
    end
    return weightGraph(myCycle),myCycle # returning the total weight and the cycle 
end
