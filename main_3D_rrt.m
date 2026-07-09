
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
map=map_definition2();


% generate random nodes
[map, nodelocation]= generate_node2(map,ns);


% define start and end point of simulation
startp=[1, 1, 1];
endp=[29, 29, 29];


% add start and end location as a new 2 nodes
nodelocation(ns+1,:)=startp;
nodelocation(ns+2,:)=endp;
snodeund=ns+1;
enodeund=ns+2;
exundnodIndex=[1:ns+2];


% create undirected graph and its edges
[undirectedGraph,unedges]=generate_undirected_graph2(map,nodelocation);


% RRT* parameters
max_iter = 5000; 
step_size = 5; 
goal_threshold = 1; 


% optimal path with RRT* on undirectional map
[path, nodes] = rrtstar_3d(map, startp, endp, max_iter, step_size, goal_threshold); clc;
if isempty(path) == 0
    rrt_star_route = path;
    rrt_star_route = [rrt_star_route; endp];
    cost = pathcost2(rrt_star_route);
    close all;
    drawRoute2_rrt('RRT*',snodeund,enodeund,nodelocation,exundnodIndex,unedges,rrt_star_route,cost,1);
end
