function T = extractTable(lineNumber,lines, numSweeps)
% Find the index of the dashed line (assuming it's the third line)
dataStartIndex = lineNumber+2; % Data starts after the dashed line

% Extract column labels from the first two rows
columnNames = strtrim(lines{dataStartIndex});
splitColumnNames = split(columnNames);
columnUnits = strtrim(lines{dataStartIndex+1});

% Read the data into a table, remove the last line
dataLines = lines(dataStartIndex+3:numSweeps+dataStartIndex+4);

% Remove dashed lines
dataLines = dataLines(~contains(dataLines, '------------------'));

data = cellfun(@(x) str2double(strsplit(strtrim(x))), dataLines, 'UniformOutput', false);
data = vertcat(data{:}); % Convert cell array to matrix

% Create the table
T = array2table(data, 'VariableNames', splitColumnNames);
end
