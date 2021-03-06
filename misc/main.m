% images are resized before any form of processing
% desired resolution of the resized image
resolution = [540; 540];

%Enable user to pick a picture
[filename, pathname] = uigetfile({'*.jpg;*.png;*.gif;*.bmp', 'All Image Files (*.jpg, *.png, *.gif, *.bmp)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Pick an image file', 'MultiSelect', 'on');
image = imread([pathname,filename]);
image = imresize(image,[resolution(1,:) resolution(2,:)]); % resize query image

% threshold input from user
% euclideanThreshold = 5000;

% gabor filter arguments
gamma = 1;
psi = 0.1;
theta = 90;
bw = 2.8;
lambda = 3.5; 
pi = 180;

%imshow(image, 'Parent', app.UIAxes);

hsvhistQuery = colourhistogram(image);

gaborImg = myGabor(image, gamma, psi, theta, bw, lambda, pi);
gaborImgMean = mean(gaborImg);
gaborImgStd = std(gaborImg);

%HISTOGRAM
%create an array of zeros 
histData_1 = zeros(1, numberOfFiles);
file_names = {};

% Get list of all JPG files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
cd images;                      % change dir to 'images'
imagefiles = dir('*.jpg');      
numberOfFiles = length(imagefiles);  % Number of files found
for ii=1:numberOfFiles
    currentfilename = imagefiles(ii).name;
    currentimage = imread(currentfilename);
    %images{ii} = currentimage;  % i dont know what this line is for
    
    % resizing to a standard resolution
    currentimage = imresize(currentimage,[resolution(1,:) resolution(2,:)]);
    
    hsvhistData = colourhistogram(currentimage);
    % disp(hsvhistData)
    result_colour = euclideanDistance(hsvhistQuery, hsvhistData);
    histData_1(1, ii) = result_colour;
    file_names = [file_names; {currentfilename}]; 
end
cd ..                           % change dir back to root folder

%sort the lowest euclidean distance 
[firstOrder, sortedOrder] = sort(histData_1);
new_fileresults = file_names(sortedOrder);
firstOrder = firstOrder(:, 1:numberOfFiles/2);
new_fileresults(numberOfFiles/2:end-1, :) = [];

% MEAN
% create an array of zeros 
mean_data = zeros(1, length(new_fileresults));
std_data = zeros(1, length(new_fileresults));
mean_file_names = {};
std_file_names = {};

% Get list of all JPG files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
cd images;                      % change dir to 'images'
imagefiles = dir('*.jpg');      
new_numberOfFiles = length(new_fileresults);  % Number of files found
for ii=1:new_numberOfFiles
    currentfilename = imagefiles(ii).name;
    currentimage = imread(currentfilename);
%   images{ii} = currentimage;  % i dont know what this line is for

    % resizing to a standard resolution
    currentimage = imresize(currentimage,[resolution(1,:) resolution(2,:)]);
    
    gabor_data = myGabor(currentimage, gamma, psi, theta, bw, lambda, pi);
    gaborMean = mean(gabor_data);
    gaborStd = std(gabor_data);
    result_mean = euclideanDistance(gaborImgMean, gaborMean);
    result_std = euclideanDistance(gaborImgStd, gaborStd);
    mean_data(1, ii) = result_mean;
    std_data(1,ii) = result_std;
    mean_file_names = [second_file_names; {currentfilename}]; 
    std_file_names = [second_file_names; {currentfilename}];
end
cd ..                           % change dir back to root folder

%sort the lowest euclidean distance 
%disp(file_names);
[meanOrder, mean_sortedOrder] = sort(mean_data);
mean_file_names = mean_file_names(mean_sortedOrder);
meanOrder = meanOrder(:, 1:new_numberOfFiles/2);
mean_file_names(new_numberOfFiles/2:end-1, :) = [];

%For standard
[stdOrder, std_sortedOrder] = sort(std_data);
std_file_names = std_file_names(std_sortedOrder);
stdOrder = stdOrder(:, 1:new_numberOfFiles/2);
std_file_names(new_numberOfFiles/2:end-1,:) = [];


% image1 = imread('image2_3.jpg');
% % gabor
% gabor1 = myGabor(image1, gamma, psi, theta, bw, lambda, pi);
% gaborMean1 = mean(gabor1);
% gaborStd1 = std(gabor1);
% % hsv histogram
% hsvhist1 = colourhistogram(image1);
% % disp(hsvhist1)
% 
% image2 = imread('image2.jpg');
% % gabor
% gabor2 = myGabor(image2, gamma, psi, theta, bw, lambda, pi);
% gaborMean2 = mean(gabor2);
% gaborStd2 = std(gabor2);
% %hsv histogram
% hsvhist2 = colourhistogram(image2);
% % disp(hsvhist2);    
% 
% % euclideanDistance(hsvhist1, hsvhist2);
% result_mean = euclideanDistance(gaborMean1, gaborMean2);
% result_std = euclideanDistance(gaborStd1, gaborStd2);
% disp(result_std);
% if result_std < 0.05 && result_mean < 1
%          disp('similar images');
%          %result = 'similar';
%      else
%          disp('dissimilar images');
%          %result = 'dissimilar';
% end

close all;