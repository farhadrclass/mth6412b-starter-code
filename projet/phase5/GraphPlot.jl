"""
Thi function plots the graphs
    Only works for graph with x,y of the nodes
    
    """
function graphPlotter(graph::Graph{T},name::String) where T
    fig = plot(legend=false)

    #first we plot the nodes
    # node positions

    # edge positions
    # for k = 1 : length(edges)
    #     for j in edges[k]
    #       plot!([nodes[k][1], nodes[j[1]][1]], [nodes[k][2], nodes[j[1]][2]],
    #           linewidth=1.5, alpha=0.75, color=:lightgray)
    #     end
    #   end

    # edge positions
    for edge in edges(graph)
        start=node1(edge).data
        finish=node2(edge).data
        plot!([start[1], finish[1]], [start[2], finish[2]],
            linewidth=1.5, alpha=0.75, color=:lightgray)
    end
  
    x = [data(node)[1] for node in nodes(graph)]
    y = [data(node)[2] for node in nodes(graph)]
    scatter!(x, y)
  
  
    scatter!(x, y)

  
    savefig("plots\\"*name*".png")
end