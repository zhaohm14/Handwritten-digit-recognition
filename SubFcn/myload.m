function variable = myload(filename)

fileStruct = load(filename);
variableNames = fieldnames(fileStruct);
variableNum = length(variableNames);
if variableNum > 1
    [variableNumber, ok] = listdlg('PromptString', 'Select a variable', ...
                                 'SelectionMode', 'single', ...
                                 'ListString', variableNames);
    if ok
        variable = eval(['fileStruct.', variableNames{variableNumber}]);
    else
        variable = [];
    end
else
    variable = eval(['fileStruct.', variableNames{1}]);
end