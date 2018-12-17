function sentenceData = getSentenceData(fn)
%GETSENTENCEDATA Flickr30k Entities sentence parser
%    This function returns an array structure containing the
%    information stored in the txt files for the Flickr30k Entities
%    dataset
%
%    Input:
%        fn - path_to_file/<image id>.txt
%
%   Outputs:
%       sentenceData - array of structs (one for each sentence)
%       with the following fields:
%            sentence - the entire image caption
%            phrases - a cell array containing the tokenized
%                       annotated phrases
%            phraseFirstWordIdx - the sentence position of the
%                                 first word of the annotated
%                                 phrase
%            phraseID - the annotation id of the phrase
%            phraseType - any course categories associated with the
%                         phrase


    if ~exist(fn,'file')
        error('file not found');
    end
    
    % Read in the file and separate by sentence
    fileID = fopen(fn,'r');
    C = textscan(fileID,'%s','Delimiter','\n');
    fclose(fileID);

    % Get tokens of all annotated phrases, using brackets as grouping tokens
    annotatedPhrases = cellfun(@(f)regexp(f,'\[(.*?)\]','tokens'),C{1},'UniformOutput',false);

    % For each annotated phrase, the first word contains the annotation information
    [entityInfo,annotatedPhrases] = cellfun(@strtok,annotatedPhrases,'UniformOutput',false);

    % Tokenize the annotated phrases and get the annotation info
    annotatedPhrases = cellfun(@(f)cellfun(@(g)textscan(g{1},'%s'),f),annotatedPhrases,'UniformOutput',false);
    [entityID,entityType] = parseEntityInfo(entityInfo);

    % Remove annotation information from the sentences,leave only the 
    % forward bracket to identify where annotation phrases begin
    sentences = cellfun(@(f)strrep(f,']',''),C{1},'UniformOutput',false);
    sentences = cellfun(@(f)regexprep(f,'\[\S* ','['),sentences,'UniformOutput',false);

    % Tokenize the sentences
    C = cellfun(@(f)textscan(f,'%s'),sentences,'UniformOutput',false);

    % Get the word number where each of the annotated phrases begins
    startPosition = cellfun(@(f)find(cellfun(@(g)~isempty(strfind(g,'[')),f{1})),C,'UniformOutput',false);

    % Remove forward brackets and format the data for output
    sentences = cellfun(@(f)strrep(f,'[',''),sentences,'UniformOutput',false);    
    sentenceData = struct('sentence',sentences,'phrases',annotatedPhrases,'phraseFirstWordIdx',startPosition,'phraseID',entityID,'phraseType',entityType);
end

function [entityID,entityType] = parseEntityInfo(entityInfo)
    % Tokenize the annotation information, using forward slash to
    % separate info (skip the [/EN# beginning each annotation)
    C = cellfun(@(g)cellfun(@(f)textscan(f{1}(5:end),'%s','Delimiter','/'),g),entityInfo,'UniformOutput',false);

    % Find sentences with annotations
    noVal = cellfun(@(f)~isempty(f),C);
    C = C(noVal);

    % The first peice of information contains the identifier for the xml file
    eID = cellfun(@(f)cellfun(@(g)g{1},f,'UniformOutput',false),C,'UniformOutput',false);

    % Rest of the information says what entity type a phrase is
    eType = cellfun(@(f)cellfun(@(g)g(2:end),f,'UniformOutput',false),C,'UniformOutput',false);


    % Format the data, leaving an empty cell for sentences that don't have annotations
    entityID = cell(length(noVal),1);
    entityType = cell(length(noVal),1);
    entityID(noVal) = eID;
    entityType(noVal) = eType;
end