function [Data_in_c,Data_out_c] = remove_days(Data_in,Data_out,num_reg,num_c)
% Input : 
% Data_in : collection of num_reg cells. Each cell is a matrix
% n_variable*n_days.
% Data_out : same structure as Data_in but n_variable different is
% possible.
% num_reg : (int) number of regions considered
% num_c : (int) number of days we want to remove

% Output : 
% Data_in_c : collection of num_reg cells. Each cell is a matrix
% n_variable*n_days_corrected.
% Data_out : same structure as Data_in but n_variable different is
% possible.
Data_in_c=cell(size(Data_in));
Data_out_c=cell(size(Data_in));

for ii = 1 : num_reg
    mat_in=Data_in{ii};
    Data_in_c{ii}=mat_in(:,num_c+1:end);
    mat_out=Data_out{ii};
    Data_out_c{ii}=mat_out(:,num_c+1:end);
end
end