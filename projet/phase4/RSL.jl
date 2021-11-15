# first find the MST
# create a tree 
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
            edges=findall(x -> x.nodes1 == node || x.node2== node , graph(myG))
            for edge in edges
                inOrder(node, myG,orderedNodes) #recursivecall
            end    
    end
    return orderedNodes
end

