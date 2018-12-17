function annotations = getAnnotations(fn)
%GETANNOTATIONS Flickr30k Entities annotation parser
%    This function returns an structure containing the information
%    stored in the txt files for the Flickr30k Entities dataset
%
%    Input:
%        fn - path_to_file/<image id>.xml
%
%   Outputs:
%       annotations - struct with the following fields:
%            image - image id of this annotation
%            ext - extension of the image
%            dims - dimenions of the image (height,width,depth)
%            id - cell array of annotation id 
%            labels - array of structs with the following fields:
%                       boxes - list of annotated boxes of the form [x1,y1,x1,y2]
%                       scene - binary label indicating if an annotation 
%                               refers to a scene
%                       nobox - binary label indicating if an annotation
%                               did not require a box and wasn't a scene
%           idToLabel - cell array containing a mapping from an id
%           index to a label index
    if ~exist(fn,'file')
        error('file not found');
    end
    outElement = struct('image',[],'ext',[],'dims',[0,0,0],'id',[],'labels',[],'idToLabel',[]);
    annoElement = struct('boxes',[],'scene',0,'nobox',0);
    root = xmlread(fn);
    allImages = root.getElementsByTagName('annotation');
    annotations = repmat(outElement,allImages.getLength,1);
    for i = 1:allImages.getLength
        image = allImages.item(i-1);
        imagefn = getDataFromTag(image,'filename');
        [annotations(i).image,rem] = strtok(imagefn{1},'.');
        annotations(i).ext = rem(2:end);
        sizeNode = image.getElementsByTagName('size').item(0);
        annotations(i).dims(2) = str2double(getDataFromTag(sizeNode,'width'));
        annotations(i).dims(1) = str2double(getDataFromTag(sizeNode,'height'));
        annotations(i).dims(3) = str2double(getDataFromTag(sizeNode,'depth'));
        objects = image.getElementsByTagName('object');
        id = cell(objects.getLength,1);
        labels = repmat(annoElement,objects.getLength,1);
        for j = 1:objects.getLength
            obj = objects.item(j-1);
            id{j} = getDataFromTag(obj,'name');
            labels(j).scene = getDataFromTag(obj,'scene');
            labels(j).nobox = getDataFromTag(obj,'nobndbox');
            if isempty(labels(j).scene)
                labels(j).boxes = getBox(obj);
            else
                labels(j).scene = str2double(labels(j).scene);
                labels(j).nobox = str2double(labels(j).nobox);
            end
        end
        uniqueID = unique(vertcat(id{:}));
        idToLabelMap = cellfun(@(f)find(cellfun(@(g)~isempty(find(strcmp(f,g),1)),id)),uniqueID,'UniformOutput',false);
        annotations(i).id = uniqueID;
        annotations(i).labels = labels;
        annotations(i).idToLabel = idToLabelMap;
    end
end

function [id,labels] = sortLabels(inputID,inputLabels,annoElement)
    id = unique(vertcat(inputID{:}));
    labels = repmat(annoElement,length(id),1);
    for i = 1:length(id)
        idLabels = inputLabels(cellfun(@(f)~isempty(find(strcmp(id{i},f),1)),inputID));
        labels(i).boxes = vertcat(idLabels.boxes);
        labels(i).scene = vertcat(idLabels.scene);
        labels(i).nobox = vertcat(idLabels.nobox);
    end
end

function box = getBox(obj)
    obj = obj.getElementsByTagName('bndbox').item(0);
    xmin = str2double(getDataFromTag(obj,'xmin'));
    xmax = str2double(getDataFromTag(obj,'xmax'));
    ymin = str2double(getDataFromTag(obj,'ymin'));
    ymax = str2double(getDataFromTag(obj,'ymax'));
    box = [xmin,ymin,xmax,ymax];
end

function data = getDataFromTag(node,tag)
    node = node.getElementsByTagName(tag);
    data = cell(node.getLength,1);
    for i = 1:node.getLength
        data{i} = char(node.item(i-1).getFirstChild.getData);
    end
end

