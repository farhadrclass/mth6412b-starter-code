#     """
# This File contain the algorithm for Prim spanning tree
# """



"""
The function to calculte prim Min spanning tree
Input  graph 
Output list of spanning trees     
"""

function PrimMST(graph::Graph{T}) where T
    # we can create a graph to hold the tree 
    # for now we init with  nodes of graph and empty edges
    # we will update the nodes later 
    #Initilize the nodes parent
    for node in nodes(graph)
        # Way two use the function in node.jl
        setParent!(node,node)
        setRank!(node,0)
    end


    # nodesList = Node{typeof(nodes(graph))}[]
    initNode  =  nodes(graph)[1]  # random start for node


    MST = Graph(string(graph.name,"PrimMST"),[initNode],Edge[])
    
    # add_node!(MST,initNode)
    # we need to sort the edge list by their weight
    sortEdge = sort(graph.edges, by = weight, rev = false)
    while length(nodes(graph)) !=length(nodes(MST))
        #first we need to get the list of nodes in MST 
        namesNodes = [name(x) for x in nodes(MST)]
        for edge in sortEdge #go through the edges 
            # check if the first node is  but second is not then we add it 
            if (!isnothing(findfirst(x-> x == name(node1(edge)), namesNodes)) && isnothing(findfirst(x-> x == name(node2(edge)), namesNodes)))
                add_node!(MST,node2(edge))
                add_edge!(MST,edge)
                break
            elseif  (isnothing(findfirst(x-> x == name(node1(edge)), namesNodes)) && !isnothing(findfirst(x-> x == name(node2(edge)), namesNodes)))
                add_node!(MST,node1(edge))
                add_edge!(MST,edge)
                break
            end
        end

    end

    # now we update the node of the MST since we changed the parents 
    return MST
end