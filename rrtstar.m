function [route, tree] = rrtstar(map, nodelocation, startnode, endnode, maxIterations, stepSize, neighborhoodRadius)
% Initialize RRT*
tree.vertices = nodelocation(startnode, :);
tree.edges = [];
tree.parents = [];
tree.costs = [0]; % Cost to reach each vertex
goalBias = 0.1; % Probability of choosing the goal as the target

for i = 1:maxIterations
    % Generate random point with goal bias
    if rand() < goalBias
        qRand = nodelocation(endnode, :);
    else
        qRand = [rand * (map.xrange(2) - map.xrange(1)) + map.xrange(1), ...
                 rand * (map.yrange(2) - map.yrange(1)) + map.yrange(1)];
    end
    
    % Find nearest vertex in the tree
    [~, idx] = min(sum((tree.vertices - qRand).^2, 2));
    qNear = tree.vertices(idx, :);
    
    % Steer towards qRand
    qNew = steer(qNear, qRand, stepSize);
    
    % Check if the new point is collision-free
    if ~checkCollision(qNear, qNew, map)
        % Find nearby vertices
        nearbyIdx = findNearbyVertices(tree, qNew, neighborhoodRadius);
        
        % Choose best parent
        [minCost, bestParentIdx] = chooseBestParent(tree, nearbyIdx, qNew, map);
        
        % Add new vertex and edge
        tree.vertices = [tree.vertices; qNew];
        newIdx = size(tree.vertices, 1);
        tree.edges = [tree.edges; bestParentIdx, newIdx];
        tree.parents = [tree.parents; bestParentIdx];
        tree.costs = [tree.costs; minCost];
        
        % Rewire the tree
        tree = rewireTree(tree, newIdx, nearbyIdx, map);
        
        % Check if we've reached the goal
        if norm(qNew - nodelocation(endnode, :)) < stepSize
            route = reconstructPath(tree, size(tree.vertices, 1));
            return;
        end
    end
end

% If no path is found, return the best partial path
[~, closestIdx] = min(sum((tree.vertices - nodelocation(endnode, :)).^2, 2));
route = reconstructPath(tree, closestIdx);
end

function qNew = steer(qNear, qRand, stepSize)
direction = qRand - qNear;
distance = norm(direction);
if distance > stepSize
    qNew = qNear + stepSize * direction / distance;
else
    qNew = qRand;
end
end

function collision = checkCollision(qNear, qNew, map)
% Check if the line between qNear and qNew intersects any obstacle
[xi, yi] = polyxpoly([qNear(1); qNew(1)], [qNear(2); qNew(2)], map.obsx, map.obsy);
collision = ~isempty(xi);
end

function nearbyIdx = findNearbyVertices(tree, qNew, radius)
distances = sqrt(sum((tree.vertices - qNew).^2, 2));
nearbyIdx = find(distances < radius);
end

function [minCost, bestParentIdx] = chooseBestParent(tree, nearbyIdx, qNew, map)
minCost = inf;
bestParentIdx = 0;

for i = 1:length(nearbyIdx)
    idx = nearbyIdx(i);
    if ~checkCollision(tree.vertices(idx,:), qNew, map)
        cost = tree.costs(idx) + norm(tree.vertices(idx,:) - qNew);
        if cost < minCost
            minCost = cost;
            bestParentIdx = idx;
        end
    end
end
end

function tree = rewireTree(tree, newIdx, nearbyIdx, map)
for i = 1:length(nearbyIdx)
    idx = nearbyIdx(i);
    if idx ~= tree.parents(newIdx-1) && ~checkCollision(tree.vertices(newIdx,:), tree.vertices(idx,:), map)
        potentialCost = tree.costs(newIdx) + norm(tree.vertices(newIdx,:) - tree.vertices(idx,:));
        if potentialCost < tree.costs(idx)
            tree.parents(idx-1) = newIdx;
            tree.costs(idx) = potentialCost;
            % Update edge
            edgeIdx = find(tree.edges(:,2) == idx);
            tree.edges(edgeIdx,:) = [newIdx, idx];
        end
    end
end
end

function path = reconstructPath(tree, goalIdx)
path = goalIdx;
while goalIdx ~= 1
    goalIdx = tree.parents(goalIdx - 1);
    path = [goalIdx, path];
end
end