% extract the whole table from lines input
function [mm,airParam,nonlinParam,nonlinL] = extractTablesFromFile(lines)
% get M(md)
searchWord = 'Specified M(md) ='; % 3.4551 grams
tableStartLine = 1;
for i = 1:length(lines)
    if contains(lines{i}, searchWord, 'IgnoreCase', false) % Case sensitive search
        tableStartLine = i; % Store the line number
        break;  % Exit the loop after finding the word
    end
end
%     Create a pattern to match the numeric value
pattern = digitsPattern + '.' + digitsPattern;  % Matches digits with a decimal point
mm = extract(lines{tableStartLine}, pattern);

% get total number of sweeps
searchWord = 'Total Number of Sweeps = '; % 19
tableStartLine = 1;
for i = 1:length(lines)
    if contains(lines{i}, searchWord, 'IgnoreCase', false) % Case sensitive search
        tableStartLine = i; % Store the line number
        break;  % Exit the loop after finding the word
    end
end
tempNS = extract(lines{tableStartLine}, digitsPattern);
numSweeps = str2double(tempNS{1});

%Loop through each line to find the word, get free air params
searchWord = 'Free Air';

tableStartLine = 1;
for i = 1:length(lines)
    if contains(lines{i}, searchWord, 'IgnoreCase', false) % Case sensitive search
        tableStartLine = i; % Store the line number
        break;  % Exit the loop after finding the word
    end
end
airParam = extractLine(tableStartLine,lines);

% Loop through each line to find the word, get nonlinear curves
searchWord = 'Vas Related';
tableStartLine = 1;
for i = 1:length(lines)
    if contains(lines{i}, searchWord, 'IgnoreCase', false) % Case sensitive search
        tableStartLine = i; % Store the line number
        break;  % Exit the loop after finding the word
    end
end

nonlinParam = extractTable(tableStartLine,lines,numSweeps);

%Loop through each line to find the word, get nonLin L 
searchWord = 'Free Air';
tableStartLine = 1;
for i = 1:length(lines)
    if contains(lines{i}, searchWord, 'IgnoreCase', false) % Case sensitive search
        tableStartLine = i; % Store the line number
        break;  % Exit the loop after finding the word
    end
end
nonlinL = extractTable(tableStartLine,lines,numSweeps);
end
