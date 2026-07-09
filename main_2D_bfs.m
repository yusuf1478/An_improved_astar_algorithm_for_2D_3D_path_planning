
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


% optimal path with BFS on undirectional map
[Route, tree] = bfs(map,nodelocation,snodeund,enodeund);
if isempty(Route) == 0
    bfs_route=nodelocation(Route,:);
    cost=pathcost(bfs_route);
    close all;
    drawRoute('BFS',snodeund,enodeund,nodelocation,exundnodIndex,unedges,Route,cost);
end
