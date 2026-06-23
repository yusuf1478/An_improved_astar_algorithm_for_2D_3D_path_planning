function drawRoute(method,startnode,endnode,exnodelocation,exnodIndex,exunedges,rt,Cost)
% draw graph nodes and selected way.

ns=size(exnodelocation,1);
map_definition();
hold on;

title([ method '  Cost:' num2str(Cost)]);
sn=exnodIndex(startnode);
en=exnodIndex(endnode);
% p1 = plot([-1 -2 -3 -4 -5 -6],[-1 -3 -1 -6 -4 -10],'-*','Color',[0 0 1]);

plot(exnodelocation(1:ns,1),exnodelocation(1:ns,2),'b*');
p2=plot(exnodelocation(sn,1),exnodelocation(sn,2),'ks','LineWidth',2,'MarkerSize',8,'MarkerFaceColor','k');
p3=plot(exnodelocation(en,1),exnodelocation(en,2),'kx','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');

% p12=plot(.5,.5,'ks','LineWidth',2,'MarkerSize',8,'MarkerFaceColor','k');
% p13=plot(9.5,9.5,'kx','LineWidth',2,'MarkerSize',10,'MarkerFaceColor','k');

for i=1:2:size(exunedges,1)    
    x1=exnodelocation(exunedges(i,1),1);
    x2=exnodelocation(exunedges(i,2),1);   
    y1=exnodelocation(exunedges(i,1),2);
    y2=exnodelocation(exunedges(i,2),2);  
    line([x1;x2],[y1;y2],'linewidth',0.1);    
end

for i=1:length(rt)-1
    x1=exnodelocation(exnodIndex(rt(i)),1);
    x2=exnodelocation(exnodIndex(rt(i+1)),1);   
    y1=exnodelocation(exnodIndex(rt(i)),2);
    y2=exnodelocation(exnodIndex(rt(i+1)),2);  
    p5=line([x1;x2],[y1;y2],'color','k','linewidth',2,'LineStyle', '-');
end

map.pgx{9}=[-10 -20 -30 -10];
map.pgy{9}=[-10 -20 -30 -10];
Npoly = size(map.pgx,2);
excluded_area=0;
for ii=1:Npoly    
    excluded_area=excluded_area+polyarea(map.pgx{ii},map.pgy{ii});
    p6=fill(map.pgx{ii},map.pgy{ii},[0.5,0.5,0.5]);
end
axis([0 30 0 30]);
hold off
