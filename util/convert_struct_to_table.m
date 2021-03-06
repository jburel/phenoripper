function [table_data,field_names]=convert_struct_to_table(data)
% CONVERT_STRUCT_TO_TABLE convert a vector of structs to a  cell array
%   [TABLE_DATA,FIELD_NAMES]=CONVERT_STRUCT_TO_TABLE(DATA) converts DATA, 
%   a vector of structs, to a cell array, TABLE_DATA. Each row of 
%   TABLE_DATA corresponds to a different element of the original vector of
%   structs, and each column corresponds to a different field of the struct
%   . It is assumed that all elements in the original vector have the same 
%   fields and the names of these fields are returned as FIELD_NAMES.
% ------------------------------------------------------------------------------
% Copyright ©2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
% For latest updates, check: < http://www.PhenoRipper.org >.
%
% All rights reserved.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% < http://www.gnu.org/licenses/ >.
%
% ------------------------------------------------------------------------------
%%



number_of_groups=length(data);
fnames=fieldnames(data{1});
table_data=cell(number_of_groups,length(fnames)-1);

for i=1:number_of_groups
    for j=1:length(fnames)-1
        table_data{i,j}=data{i}.(fnames{j+1});
    end
end
field_names=fnames(2:end);
field_names{1}='File Name';


