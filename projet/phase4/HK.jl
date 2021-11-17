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



# if true return the return MST, else calculate other stuff