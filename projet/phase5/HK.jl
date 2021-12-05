include("oneTree.jl")

"""
This File has the algorithm for Held-Karp TSM from 1970 
The  An Effective Implementation of the Lin-Kernighan Traveling Salesman Heuristic paper by Keld Helsgaun has a really good implementation on page 25 of HK


Farhad: I will try to modify the step size different from the book to be have like a sin-cos function (Similar to Machine learning)
The goal is to find a min 1-tree that has degree 2 for each node
"""


"""This function gets the root and return the ordered list of nodes after the MST has been found 
another way is to create a tree to do the same thing 
"""
function inOrderHK(root::Node{T}, myG::Graph{T}, orderedNodes:: Vector{Node{T}}=Node{T}[]) where T
    
    # if !(root in orderedNodes) 
        push!(orderedNodes, root)
    # end

    for node in nodes(myG)
        if !(node in orderedNodes) # if we already visited this then ignore, 
            # find all edges that have node as one of the nodes 
            selectEdges = findall(x -> ((name(node1(x)) == name(node) && name(node2(x)) == name(root)) || (node1(x) == name(root) && name(node2(x)) == name(node))), edges(myG))
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
Function to calculate the degree of nodes in  graph, 
"""
function degree_cal(graph::AbstractGraph)
    for node in nodes(graph)
        for edge in edges(graph)
            if name(node) == name(node1(edge)) || name(node) == name(node2(edge))
                setDegree!(node, 1)   
            end
        end    
    end
end

"""calculate V_K of a graph, this function basically update the degree of the nodes of a graph by -2
vk=dk-2 
returns TRUE if all vk ==0 , else return False
"""
function vk_cal!(graph::AbstractGraph)
    for node in nodes(graph)
        setDegree!(node, -2)   
        if(degree(node)!=0)
            return false
        end
    end
    return true
end

"""
This function returns the step size, first we do the way the paper suggested, however if I have time, I will add different method
    >   firstPeriod is a flag if we are in the first firstPeriod
    >   n is the size of graph nodes
    >   per is the period length
    >   t is the step size,
    >   flagW is true if Wk <= w(K-1)
    >   incrFlag is true if the last step of period leads to increment of w
    # >   lastStep is the true when it is the last step of period
"""
function stepSizeCal(firstPeriod::Bool, n::Union{Int64,Float64}, per::Union{Int64,Float64}, t::Union{Int64,Float64}, flagW::Bool, incrFlag::Bool)

    # Method 1 from paper
    if firstPeriod
        per = n/2
        if flagW
            t = t*2
        else 
            t = t
        end
    else
        if incrFlag
            per = per * 2
        else
            per = per /2        
        end  
        t = t/2    
    end
    #Method 2
    return Int(floor(per)) , t#Int(floor(t)) 
end




# if true return the return MST, else calculate other stuff

"""
Main HK algo
    >   graph is the original graph
    >   root is the starting point 
    >   if algo == 1 it uses Prim otherwise uses Kruskal algo  
    >   MaxIter is used to stop if we iterate more, defualt = 10000
"""
function HK_solver(algo::Int64, root::Node{T}, graph::Graph{T}, MaxIter::Int64=10000) where T
    
    myG = deepcopy(graph) # todo check if we need this 
    # Init the value
    k = 0
    w = -Inf
    w_perv= -Inf
    step = 1
    for node in nodes(myG)
        setDelta!(node,0)
    end

    firstPeriod = true
    incrFlag= false
    period = nb_nodes(myG)/2
    itera=0
    optimal = false

    MST = bestOneTree(algo, myG)
    while (period > 0 &&  step > 1*10^-6 && itera < MaxIter)
        optimal = false
        # update the weight of myG
        for edge in edges(myG)
            val = delta(node1(edge))+delta(node2(edge))
            updateWeight!(edge,val)
        end
        # find the best one tree of the new myG
        MST = bestOneTree(algo, myG)
        # calculate W_π
        W_π = weightGraph(MST) - 2* sum(delta(node) for node in nodes(MST)) 
        w_perv = w
        w = max(W_π, w)

        # reset the weight so we can do the same steps
        for edge in edges(myG)
            val = delta(node1(edge))+delta(node2(edge))
            updateWeight!(edge,(-1*val))
        end
        
        if(vk_cal!(MST))  # if vk is true then one tree is the optimal one 
            optimal=true
            break
        end

        # update the delata ,in paper it is called π_k
        
        for node in nodes(myG)
            setDelta!(node, delta(node)+ step* degree(node))
        end


        itera +=1
        
        if (itera > period ) # then the period is over
            itera = 0
            firstPeriod = false
            if (W_π>w_perv)
                incrFlag = true
            else
                incrFlag = false
            end
            period = nb_nodes(myG)/2
        end    
        period, step = stepSizeCal(firstPeriod, nb_nodes(myG),period, step, (W_π <= w_perv), (W_π>w_perv))

        
        # print(period,"---",step,"---",itera,"---","\n------\n")

        #todo Print the steps 
    end


    if optimal
        println("Optimal was found")
        # TODO should we remove the weight added by delta --I think we have removed it 
        return MST
    else # if we haven't find the optimal
        
        G = deepcopy(graph) # todo check if we need this 
        println("Optimal was NOT found")

        # #Update the weight
        for edge in edges(myG)
            val = delta(node1(edge))+delta(node2(edge))
            updateWeight!(edge,val)
        end
        # we find the RSL we new weights that has been updated 
        cycleWeight, Cycle = RSL(algo,nodes(G)[1],G)
        # reset the weight so we can update it
        for edge in edges(Cycle)
            val = delta(node1(edge))+delta(node2(edge))
            updateWeight!(edge,(-1*val))
        end

        myCycle=Graph("NewCycle",nodes(G),edges(Cycle),vert1(G),vert2(G))
        
        # change node.name to name(nodes)
        return myCycle # returning the cycle
        # return Cycle 
    end
end