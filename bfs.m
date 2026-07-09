function [route, tree] = bfs(map, nodelocation, startnode, endnode)
% Initialize BFS
tree.vertices = nodelocation;
tree.edges = [];
tree.parents = zeros(size(nodelocation, 1), 1);

% Create an adjacency list representation of the graph
graph = createGraph(map, nodelocation);

% Initialize the queue with the start node
queue = startnode;
visited = false(size(nodelocation, 1), 1);
visited(startnode) = true;

while ~isempty(queue)
    currentNode = queue(1);
    queue(1) = [];
    
    % Check if we've reached the goal
    if currentNode == endnode
        route = reconstructPath(tree, endnode);
        return;
    end
    
    % Explore neighbors
    for neighbor = graph{currentNode}
        if ~visited(neighbor)
            visited(neighbor) = true;
            queue(end+1) = neighbor;
            tree.parents(neighbor) = currentNode;
            tree.edges = [tree.edges; currentNode, neighbor];
        end
    end
end

% If no path is found, return an empty route
route = [];
end

function graph = createGraph(map, nodelocation)
% Create an adjacency list representation of the graph
numNodes = size(nodelocation, 1);
graph = cell(numNodes, 1);

for i = 1:numNodes
    for j = i+1:numNodes
        if ~checkCollision(nodelocation(i,:), nodelocation(j,:), map)
            graph{i}(end+1) = j;
            graph{j}(end+1) = i;
        end
    end
end
end

function collision = checkCollision(qNear, qNew, map)
% Check if the line between qNear and qNew intersects any obstacle
[xi, yi] = polyxpoly([qNear(1); qNew(1)], [qNear(2); qNew(2)], map.obsx, map.obsy);
collision = ~isempty(xi);
end

function path = reconstructPath(tree, goalIdx)
path = goalIdx;
while tree.parents(goalIdx) ~= 0
    goalIdx = tree.parents(goalIdx);
    path = [goalIdx, path];
end
end