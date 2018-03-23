d = dir('../data/test/left/*.jpg');
for i = 1:1:size(d)
    d(i).name
    imName = regexp(d(i).name,'\.','split');
    imName = imName(1);
    
    data = getData([], [], 'detector-car');
    model = data.model;
    col = 'r';

    imdata = getData(cell2mat(imName), 'test', 'left');
    im = imdata.im;
    f = 1.5;
    imr = imresize(im,f); % if we resize, it works better for small objects

    % detect objects
    fprintf('running the detector, may take a few seconds...\n');
    tic;
    [ds, bs] = imgdetect(imr, model, model.thresh); % you may need to reduce the threshold if you want more detections
    e = toc;
    fprintf('finished! (took: %0.4f seconds)\n', e);
    nms_thresh = 0.5;
    top = nms(ds, nms_thresh);
    if model.type == model_types.Grammar
      bs = [ds(:,1:4) bs];
    end
    if ~isempty(ds)
        % resize back
        ds(:, 1:end-2) = ds(:, 1:end-2)/f;
        bs(:, 1:end-2) = bs(:, 1:end-2)/f;
    end;
    showboxesMy(im, reduceboxes(model, bs(top,:)), col);
    fprintf('detections:\n');
    ds = ds(top, :);
    fileName = strcat(imName,'Car.txt')
    dlmwrite(cell2mat(fileName),ds);
end