""" Funtion to find min of a list and return it, then delete it from the list """
function minFindRem!(myList::Edge)
    val = minimum(myList)
    idx = findall(x -> x == val, myList)[1]
    
    minEdge = myList[idx]

    deleteat!(myList, idx)
    return minEdge
end


"""Function to find 1_tree"""
function oneTree(algo::Int64, graph::Graph{T},root::Node{T}) where T
    
    myG = deepcopy(graph)
    # remove the edges but first put them in the list to use later
    edgeList = Edge[]
    for edge in edges(myG)
        if root == edge.node1 || root == edge.node2
            push!(edgeList,edge)
        end
    end

    deleteat!(edges(myG), findall(x->(root == x.node1 || root == x.node2), edges(myG)))

    # remove the node root and all the edges from it 
    deleteat!(nodes(myG), findall(x->x==root, nodes(myG)))
    
    # find the MST 
    if algo == 1
        MST = PrimMST(myG)
    else
        MST = KruskalMST(myG)
    end 

    # find the lowest edges (2) for our 1-tree
    edge1 = minFindRem!(edgeList)
    edge2 = minFindRem!(edgeList)

    add_node!(MST,root)
    push!(MST.edges,edge1)
    push!(MST.edges,edge2)
    return MST
end

""" return the best one tree"""
function bestOneTree(algo::Int64, graph::Graph{T}) where T
    minCost= Inf
    for node in nodes(graph)
        MST= oneTree(algo, graph,node)
        MST_cost=weightGraph(MST)
        if MST_cost < minCost
            minCost = MST_cost
            myOneTree= graph("myOneTree",nodes(MST),edges(MST))
        end
    end
    return myOneTree
end