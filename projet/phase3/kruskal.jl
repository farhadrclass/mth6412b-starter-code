#     """
# This File contain the algorithm for kruskal spanning tree
# """
function FindRoot(node::Node{T}) where T
# """This function finds the  root of a node, Using recursion"""
    if node.parent == node
        return node
    end
    return FindRoot(node.parent)    
end

"""
The function to calculte Kruskal Min spanning tree
    Inspired by python code from https://www.algotree.org/algorithms/minimum_spanning_tree/kruskals/
Input  graph 
Output list of spanning trees     
"""
function KruskalMST(graph::Graph{T}) where T
    # we can create a graph to hold the tree 
    # for now we init with  nodes of graph and empty edges
    # we will update the nodes later 
    MST = Graph(string(graph.name,"MST"),graph.nodes,Edge[])
    
    #Initilize the nodes parent
    for node in nodes(graph)
        # Way one add here 
        # node.parent = node
        # node.rank = 0

        # Way two use the function in node.jl
        setParent!(node,node)
        setRank!(node,0)
    end

    # we need to sort the edge list by their weight
    sort!(graph.edges, by = weight)
    
    # Finding the MST
    for edge in edges(graph)
        root1= FindRoot(edge.node1)
        root2= FindRoot(edge.node2)

        if root1 != root2
            add_edge!(MST, edge)
            if root1.rank < root2.rank
                root1.parent = root2
                root2.rank +=1
            else
                root2.parent = root1
                root1.rank +=1
            end
        end
    end
    # now we update the node of the MST since we changed the parents 
    MST.nodes = copy(graph.nodes) # we use copy since it is a pointer type
    return MST
end