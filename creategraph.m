%creategraph.m
%version 061714
%Helen Wu
%----------------------------------------
%Graphs results given by hippocampus map script.
%Displays expression and CA1 within the CA3-CA2-CA1-subiculum line
%blue: entire length; red: expression; plain box: CA1

function [] = creategraph()
%% read in from text
numin = input('Data from how many sections? ');
[filename, pathname] = uigetfile('*.txt', 'Pick data to analyze');
fileID = fopen(filename);
str = input('Cells or boundaries? ','s');
if strcmpi('boundaries',str)
data  = fscanf(fileID,'%f %f %f %f %f\n',[5,numin]);
totaldist = data(1,:);
CA1length = data(2,:);
Tenlength = data(3,:);
CA3toCA1 = data(4,:);
CA3toTen = data(5,:);
%boundary = rectangle('Position',[0,0,totaldist(i+1)+1000,500]);
%    set(boundary,'FaceColor',[.7,.7,.7]);
%% create rectangle
for i = 0:numin-1
    totallength = rectangle('Position',[CA3toCA1(i+1)*-1,i*100,totaldist(i+1),100]);
    newx = CA3toTen(i+1)-CA3toCA1(i+1);
    Teneurinexp = rectangle('Position',[newx,25+i*100,Tenlength(i+1),50]);
    set(totallength,'FaceColor','b');
    set(Teneurinexp,'FaceColor','r');
    %CA1 rectangle - visible over expression
    rectangle('Position',[0,40+i*100,CA1length(i+1),20]);
end
elseif strcmpi('cells',str)
    data = fscanf(fileID,'%100d \n',[100,numin]);
    imagesc(data');
    end
end