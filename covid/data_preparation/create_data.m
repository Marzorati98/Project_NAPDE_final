function [Data]=create_data(data,pop_reg,out_b)
% Input :
%   - data : collections of cells, each cell corresponds to one type of
%   data (variables: hospitalized, dead,...) and it is a matrix of size
%   ('Number of regions' x 'Number of days').
%   - pop_reg : vector of population used for normalization.
%   - out_b : Translation to put first value to zero (better for the
%   learning).
%
% Output :
%   - Data : collection of cell one for each region (Italy is considered as
%   a region) each cell has a matrix 
% ('Number of variables' x 'Number of days')

% Dimension of one variable matrix 

n_var = length(data);
t_time = size(data{1},2);

% Creation of the output :
Data = cell(22,1);
for reg = 1:22
    Data{reg}=zeros(n_var,t_time);
end

% Transofrmation of the data
%{
- a) First a translation can be done to put the first value to zero.
- b) Each variable is normalized w.r.t the size of the population.
- c) Then the variable is put in the interval [0,1].
- d) Finally each variable is distributed to its correponding region.
%}
for var = 1 : n_var
    var_data=data{var};
    % a)
    if out_b
        var_data=var_data-var_data(:,1);
    end
    % b)
    var_data=var_data./pop_reg;
    
    % c)
    var_data=(var_data-min(var_data,[],2))./(max(var_data,[],2)-min(var_data,[],2));
    %var_data=(var_data-min(var_data,[],2))./(ones(22,1)-min(var_data,[],2));
    
    % d)
    for reg = 1 : 22
        reg_data=Data{reg};
        reg_data(var,:)=var_data(reg,:);
        Data{reg}=reg_data;
    end
end

end
