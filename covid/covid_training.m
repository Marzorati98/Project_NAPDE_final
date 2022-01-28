%% Fixed randomicity to reproduce experiences
clear 
close all 
stream = RandStream('dsfmt19937','Seed',3);

%% ============= 1 - Load problem - =============
%% Define the problem(s)
% Important to check all the parameters in '.ini' file before to run

problem1 = problem_get('covid','COV.ini');
problem2 = problem_get('covid','COV2.ini');

%% Load Data
load('model1_H_D_Mc_20_Ju_21','Tests','l1','l2')
dataset_save(problem1 ,Tests,'dati_cov1.mat')
% use l1 and l2 to split data in '_opt.ini'
%%
load('model2_HV_D_Mc_20_Ju_21','Tests','l1','l2')
dataset_save(problem2 ,Tests,'dati_cov2.mat')
% use l1 and l2 to split data in '_opt.ini' 
%% ============= 2 - Training and checking - =============
% Important to check all the parameters in '_opt.ini' file before to run
%% Training 
model_learn('COV_opt.ini')
%%
model_learn('COV_opt2.ini')
%% ANN model loading
learned_model_name = ''; %TODO: write here the model name 
ANNmod1 = read_model_fromfile(problem1,learned_model_name);
%ANNmod1.visualize()
learned_model_name = ''; %TODO: write here the model name 
ANNmod2 = read_model_fromfile(problem2,learned_model_name);
%ANNmod2.visualize()



     
        
        
  
