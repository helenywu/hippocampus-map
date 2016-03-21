% Hippocampus map
%6/19/14
%Helen Wu and Dominic Berns

%purpose - hippocampus
%CA1-CA2, edge of subiculum
%Condition: When clicking boundaries, always click point closer to dentate 
%gyrus first. Then click second boundary closer to subiculum.

%% Load images and display dapi channel
numim = input('How many images in the folder? ');
%filename is an array
[filename, pathname] = uigetfile('*.jpg', 'Pick an image to analyze','MultiSelect','on');
%loop through all images
str = input('Click cells or boundaries? ','s');
for numrun=1:numim
currFilename = filename{numrun};
img = imread([pathname currFilename], 'JPEG');
DAPI = img(:,:,3);
image(DAPI);
colormap(gray(256));

%% Draw line

fprintf('Draw one line through CA3, CA2, CA1, and subiculum\n');
%Use imfreehand to draw a line (not a closed ROI) through CA3-CA2-CA1-Subiculum
lineh=imfreehand('Closed',false);
%Look up imfreehand syntax - extract the points into variables
coordinates = getPosition(lineh);

%Figure out how to make the freehand line smoother
Ys = coordinates(:,2);
newYs = smoothn(Ys,75);
Xs = coordinates(:,1);
newXs = smoothn(Xs,20);
newCoord = [newXs newYs];
hold on
%Look up 'plot' syntax - plot the smooth versions of the line in different
%colors - see what parameters give the best looking line
smoothL = plot(newXs,newYs);
clear lineh;
%Measure length of line by applying distance formula to all adjacent pairs
%of points (look up 'for' loop syntax)
sum = 0;
for i=1:(size(newYs)-1)
    x1 = newXs(i);
    x2 = newXs(i+1);
    y1 = newYs(i);
    y2 = newYs(i+1);
    xdist = x2-x1;
    ydist = y2-y1;
    dist = sqrt(xdist^2 + ydist^2);
    sum = sum+dist;
end
%Use 'brushing' or 'data cursors' to define boundaries. Measure distances
%between these boundaries
fprintf('Click CA2-CA1 boundary, then click CA1-subiculum boundary\n'); 
[CA1x, CA1y] = MagnetGInput(smoothL);
[xin2, yin2] = MagnetGInput(smoothL);
j=1;
matrixsize=size(newYs);
k = matrixsize(1);
coordsize = k;
%find what data point first click corresponds to
while j<=k
    if (newXs(j) == CA1x && newYs(j) == CA1y)
        break;
    else
        j=j+1;
    end
end
CA2CA1bound = j;
%find what data point second click corresponds to
while k>=1
    if ((newXs(k) == xin2) && (newYs(k) == yin2))
        break;
    else
        k=k-1;
    end
end
%find distance sum between boundaries (length of CA1)
CA1sum = 0;
if(j>k)
    min = k;
    max = j-1;
else
    min = j;
    max = k-1;
end
%length of distance between beginning and CA1
disttoCA1 = 0;
for i=1:min
    x1 = newXs(i);
    x2 = newXs(i+1);
    y1 = newYs(i);
    y2 = newYs(i+1);
    xdist = x2-x1;
    ydist = y2-y1;
    dist = sqrt(xdist^2 + ydist^2);
    disttoCA1 = disttoCA1+dist;
end
%length of CA1
for i=min:max
    x1 = newXs(i);
    x2 = newXs(i+1);
    y1 = newYs(i);
    y2 = newYs(i+1);
    xdist = x2-x1;
    ydist = y2-y1;
    dist = sqrt(xdist^2 + ydist^2);
    CA1sum = CA1sum+dist;
end
%% Pull up ten 3 expression - red channel
if(strcmpi(str,'boundaries'))
ten3 = img(:,:,1);
image(ten3);
colormap(gray(256));
fprintf('Click boundaries of ten 3 expression\n');
[tenx1, teny1] = MagnetGInput(smoothL);
[tenx2, teny2] = MagnetGInput(smoothL);
j=1;
k = matrixsize(1);
%find what data point first click corresponds to
while j<=k
    if (newXs(j) == tenx1 && newYs(j) == teny1)
        break;
    else
        j=j+1;
    end
end
%find what data point second click corresponds to
while k>=1
    if ((newXs(k) == tenx2) && (newYs(k) == teny2))
        break;
    else
        k=k-1;
    end
end

%find distance sum between boundaries (length of teneurin 3 expression)
if(j>k)
    min = k;
    max = j-1;
else
    min = j;
    max = k-1;
end
%distance to ten 3 expression
disttoten = 0;
for i=1:min
    x1 = newXs(i);
    x2 = newXs(i+1);
    y1 = newYs(i);
    y2 = newYs(i+1);
    xdist = x2-x1;
    ydist = y2-y1;
    dist = sqrt(xdist^2 + ydist^2);
    disttoten = disttoten+dist;
end
tensum = 0;
for i=min:max
    x1 = newXs(i);
    x2 = newXs(i+1);
    y1 = newYs(i);
    y2 = newYs(i+1);
    xdist = x2-x1;
    ydist = y2-y1;
    dist = sqrt(xdist^2 + ydist^2);
    tensum = tensum+dist;
end
datafile = fopen('testagain.txt','a');
fprintf(datafile,'%f %f %f %f %f\n',sum,CA1sum, tensum, disttoCA1, disttoten);
end
%% counting cells
if strcmpi(str,'cells')
    q=curvspace(newCoord,100);
    qXs=q(:,1);
    qYs=q(:,2);
    plot(qXs,qYs);
    intensityArr = zeros(size(qYs));
    cellmap = img(:,:,2);
    cell_exp=image(cellmap);
    colormap(gray(256));
    curraxis = gca;
    currdim = axis;
    fprintf('Drag to zoom into the rectangle you create');
    rect = getrect(imgcf);
    axis([rect(1),rect(1)+rect(3),rect(2),rect(2)+rect(4)]);
    tensum=-1;
    disttoten=-1;
    fprintf('Click cells. When you are done, press space twice.\n');
    while 1
        [cellx1, celly1] = getPoint(qXs,qYs);
        if cellx1~=-1 && celly1~=-1
        j=1;
        k = matrixsize(1);
        %find what data point first click corresponds to
        while j<=k
            if (qXs(j) == cellx1 && qYs(j) == celly1)
                break;
            else
                j=j+1;
            end
        end
        intensityArr(j)=intensityArr(j)+1;
        fprintf('Click to confirm and continue or press a key to exit\n');
        press = waitforbuttonpress;
        if press==1
            break;
        end
        else
            fprintf('Too far. Did not register.\n');
        end
   %     key = get(gcf,'CurrentKey');
   %     if(strcmp (key , 'o'))
            
    end
    datafile = fopen('intensityArrays.txt','a');
    dlmwrite('intensityArrays.txt',intensityArr','-append','delimiter',' ');
    fclose(datafile);
    close(gcf);
end
end    
datafile = fopen('testagain.txt','a');
fprintf(datafile,'%f %f %f %f %f\n',sum,CA1sum, tensum, disttoCA1, disttoten);
fclose(datafile);
CA1percentage = CA1sum*100/sum;
fprintf('CA1 takes up %f%% of the area you selected.\n\n',CA1percentage);
%% Histogram for cell counts/expression intensity
if(strcmpi(str,'cells'))
    %histogram
    centers=int8([]);
    for i=1:100
        centers(i)=i;
    end
    bar(centers,intensityArr);
    %heat map
    figure;
end
creategraph();