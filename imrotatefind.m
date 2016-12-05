function [angle] = imrotatefind(im1, im2)

    ptsOriginal  = detectSURFFeatures(im1);
    ptsDistorted = detectSURFFeatures(im2);

    [featuresOriginal,   validPtsOriginal] = extractFeatures(im1, ptsOriginal);
    [featuresDistorted, validPtsDistorted] = extractFeatures(im2, ptsDistorted);

    indexPairs = matchFeatures(featuresOriginal, featuresDistorted);

    matchedOriginal  = validPtsOriginal(indexPairs(:,1));
    matchedDistorted = validPtsDistorted(indexPairs(:,2));

    [tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
       matchedDistorted, matchedOriginal, 'similarity', 'MaxNumTrials', 50000);

    showMatchedFeatures(im1, im2, inlierOriginal, inlierDistorted);
    title('Matching points (inliers only)');
    legend('ptsOriginal','ptsDistorted');
    pause(1);

    Tinv  = tform.invert.T;

    ss = Tinv(2,1);
    sc = Tinv(1,1);

    angle = atan2(ss,sc)*180/pi;
end