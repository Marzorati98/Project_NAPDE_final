function [Tests,len] = create_dataset(Data_in,Data_out,num_d, step_d, vec_reg,...
    smoothout,smoothin,prediction)
%Explanations
%{
 Input :
%   - Data_in : collection of cells as output from create_data used as
%   input for the neural network.
%   - Data_out : Same but used as output.
%   - (num_d, step_d) : moving temporal window used to select data to
%  create the different tests for the neural network.
%   - vec_reg : vector of the regions (cells in Data_in/Data_out) selected
%   for the creation.
%   - (smoothout, smoothin) : 2 vectors of boolean used to smooth data (or
%   not).
    - Prediction : boolean in the case of prediction shuffle the tests is not
    needed.
    
% Output : 
%   -Tests : collection of cells similar to the one of Data_in/Data_out but
%   with less days.
%   - len : number of tests created (control variable for '_opt.ini' file)
%}
    
Tests={};
in_t=1;
stream = RandStream('dsfmt19937','Seed',3);


for ii = 1 : length(vec_reg)
    % Here we fix the region
    region = vec_reg(ii);
    input = Data_in{region};
    output = Data_out{region};
    Tmax=length(input(1,:));
    
    % Filter (matlab function) : moving average
    %{
    We have created our own filter but the one one matlab is more flexible.
    %}
    windowSize = 10; 
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;
    
    for jj =1:length(smoothout)
        if smoothout(jj)
            output(jj,:)=filter(b,a,output(jj,:));
        end
    end
    
    for jj =1:length(smoothin)
        if smoothin(jj)
            input(jj,:)=filter(b,a,input(jj,:));
        end
    end
    % Creation of the Tests
        iter=1;
        
        while Tmax-iter>num_d
            
            Tests{in_t}.tt=0:1:num_d-1;
            Tests{in_t}.uu=input(:,iter:iter+num_d-1);
            Tests{in_t}.yy=output(:,iter:iter+num_d-1);
            
            iter = iter+step_d;
            in_t=in_t+1;
        end
        Tests{in_t}.tt=0:1:Tmax-iter;
        Tests{in_t}.uu=input(:,iter:Tmax);
        Tests{in_t}.yy=output(:,iter:Tmax);
        in_t=in_t+1;
end
if ~prediction
    Tests = Tests(randperm(stream,length(Tests)));
end
len=in_t-1; % Remove '1' to have the exact number of tests.
end
