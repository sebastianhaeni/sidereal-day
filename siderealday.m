function siderealday() 
    clear all; close all; clc; %clear matrices, close figures & clear cmd wnd.

    files = dir('./star-images/*.jpg');
    files = files(~ismember({files.name}, {'.', '..'}));

    % Start with first imageW
    prev = files(1);
    
    % Load, convert to grayscale and binarize
    previous = imbinarize(rgb2gray(imread(sprintf('%s\\%s', prev.folder, prev.name))), 'adaptive');
    numFiles = 7; % the first 8 pictures return good results with SURF
    
    % Initialize angles vector
    angles = 0:0:numFiles;

    for i = 2:numFiles
        % Print progress
        sprintf('%3.2f%%\n', ((i-1)/numFiles)*100)

        file = files(i);
        filename = sprintf('%s\\%s', file.folder, file.name);
        
        % Load, convert to grayscale and binarize
        current = imbinarize(rgb2gray(imread(filename)), 'adaptive');

        % Find rotation
        angles(i-1) = imrotatefind(previous, current);

        previous = current;
    end

    curve = cumsum(angles);

    time = 0:20:((numFiles - 2) * 20);
    P = polyfit(time, curve, 1);

    minutesPerDay = 360/P(1);
    secondsPerDay = minutesPerDay * 60;

    siderealDaySeconds = 86164.099;

    diff = abs(secondsPerDay - siderealDaySeconds);
    relativeError = diff / siderealDaySeconds;
    sprintf('Relative error: %3.3f%%', relativeError * 100)

end