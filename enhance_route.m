function [ggnode,ggedges,gggraph]=enhance_route(map, wroute, wbol)
% wbol=5;
% bbnode=[1 3; 4 -3; 3 2; 5 6; 4 -1];
% bbroute=[1 2 3 4 5];
bbnode=wroute;
bbroute=[1:size(wroute,1)];

% hold on;
ggnode=[];
gggraph=zeros(wbol*(size(bbnode,1)-1)+1,wbol*(size(bbnode,1)-1)+1);
for i=1:size(bbnode,1)-1
  ggnode=[ggnode; bbnode(bbroute(i),:)];
  x1=bbnode(bbroute(i),1);
  x2=bbnode(bbroute(i+1),1);   
  y1=bbnode(bbroute(i),2);
  y2=bbnode(bbroute(i+1),2); 
%   plot(x1,y1,'rx','markersize',10);
%   line([x1;x2],[y1;y2],'linewidth',0.1);
  xort=(x2-x1)/wbol;
  yort=(y2-y1)/wbol;
  for j=1:wbol-1
    x3=x1+xort*j;
    y3=y1+yort*j;
    ggnode=[ggnode; x3 y3];
%     plot(x3,y3,'rx','markersize',10);
  end
end
ggnode=[ggnode; bbnode(bbroute(size(bbnode,1)),:)];

ggedges=[];
for i=1:size(ggnode,1)-1 
    for j=i+1:size(ggnode,1)
        % take each pair of node^s location x and y
        x1=[ggnode(i,1);ggnode(j,1)];
        y1=[ggnode(i,2);ggnode(j,2)];  
        % check this two nodes intersect any obstacle or not
        [xi,yi] = polyxpoly(x1,y1,map.obsx,map.obsy);
        % if there is not any intersection
        if length(xi)==0
            % connect this two nodes in graph
            gggraph(i,j)=1;
            gggraph(j,i)=1;
            % add this connection to adge set
            ggedges=[ggedges;i j;j i];
        end
    end
end
