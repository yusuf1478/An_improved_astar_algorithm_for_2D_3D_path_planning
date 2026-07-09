function [route] = bfs3d(exbigraph, exbiloc, startnode, endnode)

graph = exbigraph;
Loc = exbiloc;
n = size(graph, 1);

% Initialize variables
visited = false(n, 1); % To keep track of visited nodes
prev = -1 * ones(n, 1); % To reconstruct the path

queue = [startnode]; % Queue for BFS
visited(startnode) = true;

% Perform BFS
while ~isempty(queue)
    curr = queue(1);
    queue(1) = []; % Dequeue the first element
    
    if curr == endnode
        break;
    end
    
    % Get all neighbors of the current node
    neighbors = find(graph(curr, :) == 1);
    
    for i = 1:length(neighbors)
        neighbor = neighbors(i);
        if ~visited(neighbor)
            queue(end + 1) = neighbor; % Enqueue the neighbor
            visited(neighbor) = true;
            prev(neighbor) = curr; % Store the path
        end
    end
end

% Reconstruct the path from endnode to startnode
route = [];
if visited(endnode)
    route = [endnode];
    while route(1) ~= startnode
        route = [prev(route(1)), route];
    end
end

end
