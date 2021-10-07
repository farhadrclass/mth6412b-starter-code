"""
This program reads a symmetric TSP instance whose weights are given in EXPLICIT format and builds a corresponding Graph object.
"""

# Import the other files    
include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

include("kruskal.jl")



# read the graph from the file 
cd("instances\\stsp\\")# go to the file for data
graphName = "gr17"  # this name used for name of the graph
fileName = string(graphName,".tsp")
graph_nodes, graph_edges = read_stsp(fileName)


# nodesList = AbstractNode[]
if (length(graph_nodes) > 0) # check to see if the name is assigned in the TSP file, if not we do something else 
    nodesList = Node{typeof(graph_nodes[1])}[]
else
    nodesList = Node{Int64}[]
end


for k=1:length(graph_edges)
    if (length(graph_nodes) > 0) # check to see if the name is assigned in the TSP file, if not we do something else 
        node_buff = Node(string(k),graph_nodes[k],nothing ,0)
    else
        node_buff = Node(string(k), k, nothing ,0) #name is the same as we assign it 
    end
    push!(nodesList,node_buff)
end

 # edge positions
 # go through the edge list and create the edges of the graph


edgesList=Edge[]
# edgesList = AbstractEdge[]
#TODO update this for phase 3 check for bayg29

# add a flag if the nodes are read then you have a edge list then use it to get the node then assign 

 for k = 1 : length(graph_edges)
    for j = 1 : length(graph_edges[k])
        edge_buff = Edge(nodesList[k], nodesList[j], graph_edges[k][j][2])
        push!(edgesList, edge_buff)
    end
  end


# create a graph using data types
G = Graph(graphName, nodesList, edgesList)
show(G)
# Testing Kruskal
MST = KruskalMST(G)
show(G)