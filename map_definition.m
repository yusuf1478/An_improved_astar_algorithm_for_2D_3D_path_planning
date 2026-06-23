function map=map_definition()

% clc;
% clear;
% close all;

%%%% sample map
% Npoly=13;
% map.pgx{1}=[2 8.5 8.5 4 2 2 1 1 2 4 2];
% map.pgy{1}=[8 10 1 3 3 1 1 6 6 5 8];
% map.pgx{2}=[2 8 2 15 2 1 1 2 2];
% map.pgy{2}=[10 16 22 15.5 9 10 16 16 10];
% map.pgx{3}=[0 0 5 0];
% map.pgy{3}=[25 30 30 25];
% map.pgx{4}=[7 7 10 10 13 13 11 7];
% map.pgy{4}=[23 26 29 25 26 23 21 23];
% map.pgx{5}=[13 17 15 13];
% map.pgy{5}=[30 30 25  30];
% map.pgx{6}=[17 17 30 30 17];
% map.pgy{6}=[23 27 27 23 23];
% map.pgx{7}=[12 14 15 16 29 23 27 19 12];
% map.pgy{7}=[20 21 23 21.3 22 10 21.3 14 20];
% map.pgx{8}=[10 15 17.5 10 10];
% map.pgy{8}=[8 14 10 0 8];
% map.pgx{9}=[19 24 19 19];
% map.pgy{9}=[12.5 17 1 12.5];
% map.pgx{10}=[21 30 26 21];
% map.pgy{10}=[3 16 1 3];
% map.pgx{11}=[4 7 8 6 5 10 7 4 4];
% map.pgy{11}=[25 30 30 26 23 20 21 23 25];
% map.pgx{12}=[0 0 4 5 4 3 3 0];
% map.pgy{12}=[17 18 18 16 14 14 17 17];
% map.pgx{13}=[3 3 4 4 3];
% map.pgy{13}=[0 2 2 0 0];


%%%% map 1
map.pgx{1}=[3 3 10 10 3];
map.pgy{1}=[0 20 20 0 0];
map.pgx{2}=[0 13 13 0 0];
map.pgy{2}=[25 25 30 30 25];
map.pgx{3}=[12 17 23 12];
map.pgy{3}=[0 9 0 0];
map.pgx{4}=[13 13 20 13];
map.pgy{4}=[9 20 25 9];
map.pgx{5}=[22 22 30 30 22];
map.pgy{5}=[25 28 28 25 25];
map.pgx{6}=[30 23 18 23 30 30];
map.pgy{6}=[22 22 13 4 4 22];
Npoly = size(map.pgx,2);
map.startp=[1, 1];
map.endp=[29, 29];

%%%% map 2
% map.pgx{1}=[0 10 3 0 0];
% map.pgy{1}=[20 23 30 30 20];
% map.pgx{2}=[0 14 14 0 0];
% map.pgy{2}=[5 10 13 16 5];
% map.pgx{3}=[8 15 20 10];
% map.pgy{3}=[0 6 0 0];
% map.pgx{4}=[13 15 10 17 22 17 13];
% map.pgy{4}=[30 23 18 18 25 30 30];
% map.pgx{5}=[25 25 20 22 25 30 30 25];
% map.pgy{5}=[0 5 14 17 14 16 0 0];
% map.pgx{6}=[30 25 23 30 30];
% map.pgy{6}=[23 18 20 28 23];
% map.pgx{7}=[17 16 18 20 17];
% map.pgy{7}=[8 14 16 10 8];
% map.pgx{8}=[22 24 27 22];
% map.pgy{8}=[30 27 30 30];
% map.pgx{9}=[5 7 9 6 5];
% map.pgy{9}=[3 3 6 5 3];
% Npoly = size(map.pgx,2);
% map.startp=[1, 1];
% map.endp=[29, 29];


map.xrange=[0 30];
map.yrange=[0 30];

figure;
set(gcf,'color','w');
box on;
xlabel 'x'; ylabel 'y'; grid on;
hold on

excluded_area=0;

for ii=1:Npoly    
    excluded_area=excluded_area+polyarea(map.pgx{ii},map.pgy{ii});
    p1=fill(map.pgx{ii},map.pgy{ii},[0.5,0.5,0.5]);


hold off



