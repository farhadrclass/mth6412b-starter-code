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
include("RSL.jl")
include("HK.jl")
include("GraphPlot.jl")


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
            node_buff = Node(string(k),graph_nodes[k],nothing ,0,0,0)
        else
            node_buff = Node(string(k),k, nothing ,0,0,0) #name is the same as we assign it 
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

OptimalVal=Dict("bayg29" =>  1610,
"bays29" =>  2020,
"brazil58" =>  25395,
"brg180" =>  1950,
"dantzig42" =>  699,
"fri26" =>  937,
"gr17" =>  2085,
"gr21" =>  2707,
"gr24" =>  1272,
"gr48" =>  5046,
"gr120" =>  6942,
"hk48" =>  11461,
"pa561" =>  2763,
"swiss42" =>  1273)

# G= createGraph("instances\\stsp\\","gr120")
G= createGraph("instances\\stsp\\","bayg29")
newG= deepcopy(G)

# # show(G)
MST = KruskalMST(G)


println(nb_edges(MST))
graphPlotter(MST,"bayg29_MST_Kruskal")
MST = PrimMST(G)
graphPlotter(MST,"bayg29_MST_Prim")

cycleWeight, Cycle = RSL(1,nodes(G)[1],G)

graphPlotter(Cycle,"bayg29_MST_Prim_RSL")


HK_cycle= HK_solver(1, nodes(newG)[1], newG, 10000000000000)  #TODO check HK Solver if it overwrites the graph

graphPlotter(HK_cycle,"bayg29_MST_Prim_HK")



#Testing the nodes as root  RSL 
global minW=Inf
global cc=0
for node in nodes(G)
    cycleWeight, Cycle = RSL(1,node,G)
    if cycleWeight <  minW
        global cc+=1
        global minW = cycleWeight
        global BestCycle = Cycle
        if(cc>2) # we only take 3 updates 
            break
        end
    end
end
println("The weight of RSL for graph ", "bayg29"," is ",minW,"  Optimal Value is ", OptimalVal["bayg29"] )


graphPlotter(BestCycle,"bayg29_MST_Prim_RSL_Best")
## show(BestCycle)

println("Reading all the files now\n\n\n")
for fileName in readdir("instances\\stsp\\")
    fileName =replace(fileName, ".tsp" => "") # removing tsp since createGraph expcet only the name 
    println("reading the file: " ,fileName) 
    BufferG= createGraph("instances\\stsp\\",fileName)
    newG= deepcopy(BufferG)
    # Testing Kruskal
    MST = KruskalMST(BufferG)
    println("The weight of KruskalMST for graph ", fileName," is ",weightGraph(MST)," and number of edges are ",nb_edges(MST))
    println()

    MST = PrimMST(BufferG)
    println("The weight of PrimMST for graph ", fileName," is ",weightGraph(MST)," and number of edges are ",nb_edges(MST))
    println()

    cycleWeight, Cycle = RSL(1,nodes(BufferG)[1],BufferG)
    println("The weight of RSL for graph ", fileName," is ",cycleWeight,"  Optimal Value is ", OptimalVal[fileName] )
    if(cycleWeight>2*OptimalVal[fileName]) # this is what Prof. Orban suggested 
        println("The value of True is larger than 2* optimal value, we will test the triangle inequality hewre to make sure if it correct")
        flag=false
        #Trinagle Inequality
        for edge in edges(BufferG)
            for node in nodes(BufferG)
                if node != node1(edge) && node != node2(edge) # if the node isn't on the edge
                    e1 = findfirst(x-> (node1(x)==node && node2(node1(edge)))||(node2(x)==node && node1(node1(edge))),edges(BufferG)) 
                    e2 = findfirst(x-> (node1(x)==node && node2(node2(edge)))||(node2(x)==node && node1(node2(edge))),edges(BufferG)) 
                    if(weight(edge)>weight(e1)+weight(e2))
                        flag=true
                        print("Violate the triangle")
                        break
                    end
                    if(flag)
                        break
                    end
                end
            end
        end
    end

    println()
    HK_cycle= HK_solver(1, nodes(newG)[1], newG, 10000000000000) 

    println("The weight of HK Cycle for graph ", fileName," is ",weightGraph(HK_cycle),"  Optimal Value is ", OptimalVal[fileName] )
    println()




    println("------------------------------------------------------")
end


