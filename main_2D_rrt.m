
% This project builds upon the A* path planning implementation 
% from the FOMR-1 project (https://github.com/joedavidbuilds/FOMR-1). 
% Significant modifications and improvements were introduced by 
% Rustu Akay & Mustafa Yusuf Yildirim to improve path planning efficiency.
% akay@erciyes.edu.tr
% yusufyildirim@ohu.edu.tr 

clc;
clear;
close all;


% number of nodes 
ns=50;
map=map_definition();


% generate random nodes
[map, nodelocation]= generate_node(map,ns);


% define start and end point of simulation
% startp=[5, 29];
% endp=[29, 20];
startp=map.startp;
endp=map.endp;


% add start and end location as a new 2 nodes
nodelocation(ns+1,:)=startp;
nodelocation(ns+2,:)=endp;
snodeund=ns+1;
enodeund=ns+2;
exundnodIndex=[1:ns+2];


% create undirected graph and its edges
[undirectedGraph,unedges]=generate_undirected_graph(map,nodelocation);


% RRT* parameters
maxIterations = 1500; 
stepSize = 1; 
neighborhoodRadius = 2; 


% optimal path with RRT* on undirectional map
[Route, tree] = rrtstar(map, nodelocation, snodeund, enodeund, maxIterations, stepSize, neighborhoodRadius);
if isempty(Route) == 0
    rrt_star_route = tree.vertices(Route, :);
    rrt_star_route = [rrt_star_route; endp];
    cost = pathcost(rrt_star_route);
    close all;
    drawRoute('RRT*',snodeund,enodeund,tree.vertices,1:size(tree.vertices,1),[],Route,cost);
end
