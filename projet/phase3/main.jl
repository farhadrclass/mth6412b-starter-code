"""
This program reads a symmetric TSP instance whose weights are given in EXPLICIT format and builds a corresponding Graph object.
"""

# Import the other files    
include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

include("kruskal.jl")
include("prim.jl")


function createGraph(path, graphName)
    # read the graph from the file 
    localGraphName=string(path,graphName)
    fileName = string(localGraphName,".tsp")
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

    # add a flag if the nodes are read then you have a edge list then use it to get the node then assign 

    for k = 1 : length(graph_edges)
        for item in graph_edges[k]
            edge_buff = Edge(nodesList[k], nodesList[item[1]],item[2])
            push!(edgesList, edge_buff)
        end
    end


    # create a graph using data types
    # G = Graph(graphName, nodesList, edgesList)
    G = Graph(graphName, nodesList, Edge[])

    #adding the edges here so we test there is no dublicate 
    for k =1:length(edgesList)
        add_edge!(G,edgesList[k])
    end


    # show(G)
    G
end


G= createGraph("instances\\stsp\\","bayg29")
show(G)
MST = KruskalMST(G)
show(MST)
println(weightGraph(G))

println(weightGraph(MST))
# println(MST.edges)

# Testing Kruskal
# MST = KruskalMST(G)
# show(G)
println("Reading all the files now\n\n\n")
for fileName in readdir("instances\\stsp\\")
    fileName =replace(fileName, ".tsp" => "") # removing tsp since createGraph expcet only the name 
    println("reading the file: " ,fileName) 
    BufferG= createGraph("instances\\stsp\\",fileName)
    # Testing Kruskal
    MST = KruskalMST(BufferG)
    println("The weight of KruskalMST for graph ", fileName," is ",weightGraph(MST)," and number of edges are ",nb_edges(MST))
    println()

    MST = PrimMST(BufferG)
    println("The weight of PrimMST for graph ", fileName," is ",weightGraph(MST)," and number of edges are ",nb_edges(MST))
    println("------------------------------------------------------")
end