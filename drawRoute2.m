function drawRoute2(method,startnode,endnode,nodelocation,exnodIndex,unedges,rt,Cost,wfull)
% draw graph nodes and selected way.

ns=size(nodelocation,1);
map_definition2();
hold on;

title([ method '  Cost:' num2str(Cost)]);
sn=exnodIndex(startnode);
en=exnodIndex(endnode);
% plot3(nodelocation(1:ns,1),nodelocation(1:ns,2),nodelocation(1:ns,3),'b*');
plot3(nodelocation(sn,1),nodelocation(sn,2),nodelocation(sn,3),'kx','markersize',10);
plot3(nodelocation(en,1),nodelocation(en,2),nodelocation(en,3),'kx','markersize',10);

if (wfull==1)
  for i=1:2:size(unedges,1)    
    x1=nodelocation(unedges(i,1),1);
    x2=nodelocation(unedges(i,2),1);     
    y1=nodelocation(unedges(i,1),2);
    y2=nodelocation(unedges(i,2),2);  
    z1=nodelocation(unedges(i,1),3);
    z2=nodelocation(unedges(i,2),3); 
%     line([x1;x2],[y1;y2],[z1;z2],'linewidth',0.1);    
  end
end

for i=1:length(rt)-1
    x1=nodelocation(exnodIndex(rt(i)),1);
    x2=nodelocation(exnodIndex(rt(i+1)),1);   
    y1=nodelocation(exnodIndex(rt(i)),2);
    y2=nodelocation(exnodIndex(rt(i+1)),2);  
    z1=nodelocation(exnodIndex(rt(i)),3);
    z2=nodelocation(exnodIndex(rt(i+1)),3);  
    line([x1;x2],[y1;y2],[z1;z2],'color','k','linewidth',2);
end
hold off
