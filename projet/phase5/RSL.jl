# first find the MST
# create a tree  then dfs the tree or just find the ordered list of the nodes
# pree order the nodes
# add the edges between them 
# return 
# Import the other files    
# include("node.jl")
# include("edge.jl")
# include("graph.jl")
# include("read_stsp.jl")

# include("kruskal.jl")
# include("prim.jl")

"""This function gets the root and return the ordered list of nodes after the MST has been found 
another way is to create a tree to do the same thing 
"""
function inOrder(root::Node{T}, myG::Graph{T}, orderedNodes:: Vector{Node{T}}=Node{T}[]) where T
    
    # if !(root in orderedNodes) 
        push!(orderedNodes, root)
    # end

    for node in nodes(myG)
        if !(node in orderedNodes) # if we already visited this then ignore, 
            # find all edges that have node as one of the nodes 
            selectEdges = findall(x -> ((node1(x) == node && node2(x) == root) || (node1(x) == root && node2(x) == node)), edges(myG))
            # selectEdges = findall(x -> ((name(node1(x)) == name(node) && name(node2(x)) == name(root)) || (node1(x) == name(root) && name(node2(x)) == name(node))), edges(myG))

            if(length(selectEdges)>=1)
                for i in selectEdges
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

    # show(MST)
    # pre order the nodes
    # WE assusme the graph is complete 
    preOrder = inOrder(root, MST)
    push!(preOrder, root) # adding the first node agian to make it a round
    myCycle = Graph("Hamiltonian Cycle",nodes(myG),Edge[])
    for i in 1:length(preOrder) - 1
        current= preOrder[i]
        next = preOrder[i+1]
        idx = findfirst(x -> ((name(node1(x)) == name(current) && name(node2(x)) == name(next)) || (name(node1(x)) == name(next) && name(node2(x)) == name(current))) , edges(myG)) # find where current and next node are 
        add_edge!(myCycle, edges(myG)[idx])
    end
    # change node.name to name(nodes)
    return weightGraph(myCycle),myCycle # returning the total weight and the cycle 
end
