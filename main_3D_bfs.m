
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


% optimal path with BFS on undirectional map
[Route] = bfs3d(undirectedGraph,nodelocation,snodeund,enodeund);
if isempty(Route) == 0
    bfs_route=nodelocation(Route,:);
    cost=pathcost2(bfs_route);
    close all;
    drawRoute2('BFS',snodeund,enodeund,nodelocation,exundnodIndex,unedges,Route,cost,1);
end
