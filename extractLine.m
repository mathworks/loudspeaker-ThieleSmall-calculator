% extract the middle line entry from lines input
 function TT = extractLine(lineNumber,lines)
% Find the index of the dashed line (assuming it's the third line)
dataStartIndex = lineNumber+2; % Data starts after the dashed line

% Extract column labels from the first two rows
columnNames = strtrim(lines{dataStartIndex});
splitColumnNames = split(columnNames);
columnUnits = strtrim(lines{dataStartIndex+1});
tempColumnUnits = split(columnUnits);
splitColumnUnits = cell(length(splitColumnNames),1);
splitColumnUnits(2:6) =  tempColumnUnits(1:5);
splitColumnUnits(10:12) = tempColumnUnits(6:8);

% locate dashed lines
dashLines = contains(lines, '------------------');
firstNonzeroIndex = find(dashLines, 4, 'first');
if (firstNonzeroIndex(4)-firstNonzeroIndex(3)) ~= 2
    disp('error, import failed')
end

% data is the first line after the third dashed line 
targetData = lines(firstNonzeroIndex(3)+1);

data = cellfun(@(x) str2double(strsplit(strtrim(x))), targetData, 'UniformOutput', false);
data = vertcat(data{:}); % Convert cell array to matrix

% Create the table
T = array2table(data, 'VariableNames', splitColumnNames);
TT = [T; splitColumnUnits.'];

end
