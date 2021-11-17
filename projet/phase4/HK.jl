"""
This File has the algorithm for Held-Karp TSM from 1970 
The  An Effective Implementation of the Lin-Kernighan Traveling Salesman Heuristic paper by Keld Helsgaun has a really good implementation on page 25 of HK


Farhad: I will try to modify the step size different from the book to be have like a sin-cos function (Similar to Machine learning)
The goal is to find a min 1-tree that has degree 2 for each node
"""


"""
Function to calculate the degree of nodes in  graph, 
"""
function degree_cal(graph::AbstractGraph)
    for node in nodes(graph)
        for edge in edges(graph)
            if node == edge.node1 || node == edge.node2
                setDegree!(node, 1)   
            end
        end    
    end
end

"""calculate V_K of a graph, this function basically update the degree of the nodes of a graph by -2
vk=dk-2 
returns TRUE if all vk ==0 , else return False
"""
function vk_cal(graph::AbstractGraph)
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
    >   lastStep is the true when it is the last step of period
"""
function stepSizeCal(firstPeriod::Bool,n::Int64, per::Int64, t::Int64, flagW::Bool, incrFlag::Bool, lastStep::Bool)

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





    return per, t
end



# if true return the return MST, else calculate other stuff