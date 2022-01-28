%% ============= - Create dataset - =============
close all
clear
%% Create Dataset

your_folder = '/Users/model_learning/examples/covid';

stream = RandStream('dsfmt19937','Seed',3); % Reproducible results

load('Dati_covid_vac2.mat', 'tot_hospi','dead','pop_reg','Days_cov',...
    'vaccinated_1d','names','R_star','Rmox_it','Days_mox');

% Other possibilities :
%{
'vaccinated_2d','vaccinated_3d','ricoverati_con_sintomi','tera_intensive',
%'isolamenti', 'var_tot_pos','new_pos','dimessi_guariti','tot_pos',
% 'tot_case','test' (cf data_extraction)
%}
%% Plot data to see 
% for Lombardia (9)
figure()
plot(Days_cov,dead(9,:))

xtickangle(45)
ylabel('number of death per day')
set(findall(gcf,'-property','FontSize'),'FontSize',20)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2.5)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',12)

Data_out = create_data({dead(:,find(Days_cov=='24-Feb-2020'):...
    find(Days_cov=='21-Jan-2022'))},pop_reg,true);
dead_norm=Data_out{9};
Data_in = create_data({tot_hospi(:,find(Days_cov=='24-Feb-2020'):...
    find(Days_cov=='21-Jan-2022'))},pop_reg,false);
%%
figure()
plot(Days_cov,dead_norm)

xtickangle(45)
ylabel('death normalized per day')
set(findall(gcf,'-property','FontSize'),'FontSize',20)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2.5)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',12)
grid on
% Moving window to create data
num_d=10000;
step_d=35000;

% Smooth (or not) the data
smooth_in=false;
smooth_out=true;

[Test1,l1]=create_dataset(Data_in,Data_out,num_d, step_d, 9,smooth_out,smooth_in,true);

%%
test=Test1{1};
figure()
plot(test.tt,test.yy)
grid on 
grid MINOR
xtickangle(45)
ylabel('death normalized per day')
set(findall(gcf,'-property','FontSize'),'FontSize',20)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2.5)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',12)

%% Create a dataset: some information
% First wave: 01-Feb-2020 // 01-May-2020
% Second wave: 01-Nov-2020 // 01-Jan-2021
% Third wave: 01-Mar-2021 // 01-Jun-2021
% Fourht wave: 
% Fifth wave:
% Vaccination: 

%% Test model 1  input  : ospedalizzati ; output : deceduti 
%{
% Try to predict the number of dead people w.r.t 
% the numbers of hopitalized people 
% Expected : t_norm = 30

% Moving window to create data
num_d=100;
step_d=35;

% Smooth (or not) the data
smooth_in=false;
smooth_out=true;

% Data selected (change the days of beginning and ending)
% Attention : for vaccination data use Days_vac, others use Days_cov !

Data_in = create_data({tot_hospi(:,find(Days_cov=='01-Mar-2020'):...
    find(Days_cov=='01-Jul-2021'))},pop_reg,false);
Data_out = create_data({dead(:,find(Days_cov=='01-Mar-2020'):...
    find(Days_cov=='01-Jul-2021'))},pop_reg,true);

% Shuffle the regions and select one part for the training, the other for
% the Validation.

vec_reg=1:1:22;
vec_reg=vec_reg(randperm(stream,length(vec_reg)));

%Training
[Test1,l1]=create_dataset(Data_in,Data_out,num_d, step_d, vec_reg(1:16),smooth_out,smooth_in,false);

% Validation
[Test2,l2]=create_dataset(Data_in,Data_out,num_d, step_d, vec_reg(17:22),smooth_out,smooth_in,false);

% Save data 
Tests=[Test1,Test2];
path_file = fullfile(your_folder,'model1_H_D_Mc_20_Ju_21.mat'); % Data file name
save(path_file,'Tests','l1','l2')
% l1 and l2 are used to indicate where to split data (Training,
% Validation, Test)in the "_opt.ini" file.
%}
%% Test model 2  input  : ospedalizzati, vacinated_1d ; output : deceduti 
%{
% Try to predict the parameter R* w.r.t
% the numbers of vaccinated (first dose) people 
% Expected : t_norm = 30

% Moving window to create data
num_d=100;
step_d=35;

% Smooth (or not) the data
smooth_in=false;
smooth_out=true;

% Data selected (change the days of beginning and ending)
% Attention : for vaccination data use Days_vac, others use Days_cov !

Data_in = create_data({vaccinated_1d(:,find(Days_cov=='01-Mar-2020'):...
    find(Days_cov=='01-Jul-2021')),tot_hospi(:,find(Days_cov=='01-Mar-2020'):...
    find(Days_cov=='01-Jul-2021'))},pop_reg,false);
Data_out = create_data({dead(:,find(Days_cov=='01-Mar-2020'):...
    find(Days_cov=='01-Jul-2021'))},pop_reg,true);

% Shuffle the regions and select one part for the training, the other for
% the Validation.

vec_reg=1:1:22;
vec_reg=vec_reg(randperm(stream,length(vec_reg)));

%Training
[Test1,l1]=create_dataset(Data_in,Data_out,num_d, step_d, vec_reg(1:16),...
    smooth_out,smooth_in,false);

% Validation
[Test2,l2]=create_dataset(Data_in,Data_out,num_d, step_d, vec_reg(17:22),...
    smooth_out,smooth_in,false);

% Save data 
Tests=[Test1,Test2];
% Data file name
path_file = fullfile(your_folder,'model2_HV_D_Mc_20_Ju_21.mat'); 
save(path_file,'Tests','l1','l2')
%}
%% Test model 2bis  input  : ospedalizzati, vacinated_1d ; output : deceduti 
%{
% Try to predict the parameter R* w.r.t
% the numbers of vaccinated (first dose) people 
% Expected : t_norm = 30

% Moving window to create data
num_d=100;
step_d=35;

% Smooth (or not) the data
smooth_in=false;
smooth_out=true;

% Data selected (change the days of beginning and ending)
% Attention : for vaccination data use Days_vac, others use Days_cov !

Data_in = create_data({vaccinated_1d(:,find(Days_cov=='01-Feb-2021'):...
    find(Days_cov=='01-Jul-2021')),tot_hospi(:,find(Days_cov=='01-Feb-2021'):...
    find(Days_cov=='01-Jul-2021'))},pop_reg,false);
Data_out = create_data({dead(:,find(Days_cov=='01-Feb-2021'):...
    find(Days_cov=='01-Jul-2021'))},pop_reg,true);

% Shuffle the regions and select one part for the training, the other for
% the Validation.

vec_reg=1:1:22;
vec_reg=vec_reg(randperm(stream,length(vec_reg)));

%Training
[Test1,l1]=create_dataset(Data_in,Data_out,num_d, step_d, vec_reg(1:16),...
    smooth_out,smooth_in,false);

% Validation
[Test2,l2]=create_dataset(Data_in,Data_out,num_d, step_d, vec_reg(17:22),...
    smooth_out,smooth_in,false);

% Save data 
Tests=[Test1,Test2];
path_file = fullfile(your_folder,'model2_HV_D_F_21_Jul_21.mat'); % Data file name
save(path_file,'Tests','l1','l2')
%}
%% Test model 3  input  : ospedalizzati, vacinated_1d ; output : deceduti 
%{
% Try to predict the parameter R* w.r.t
% the numbers of vaccinated (first dose) people 
% Expected : t_norm = 30

% Moving window to create data
num_d=100;
step_d=35;

% Smooth (or not) the data
smooth_in=false;
smooth_out=true;

% Data selected (change the days of beginning and ending)
% Attention : for vaccination data use Days_vac, others use Days_cov !

Data_in = create_data({vaccinated_1d(:,find(Days_vac=='01-Jan-2021'):...
    find(Days_vac=='01-Jul-2021')),tot_hospi(:,find(Days_cov=='01-Jan-2021'):...
    find(Days_cov=='01-Jul-2021'))},pop_reg,false);
Data_out = create_data({dead(:,find(Days_cov=='01-Jan-2021'):...
    find(Days_cov=='01-Jul-2021'))},pop_reg,true);

% Shuffle the regions and select one part for the training, the other for
% the Validation.

vec_reg=1:1:22;
vec_reg=vec_reg(randperm(stream,length(vec_reg)));

%Training
[Test1,l1]=create_dataset(Data_in,Data_out,num_d, step_d, vec_reg(1:16),...
    smooth_out,smooth_in,false);

% Validation
[Test2,l2]=create_dataset(Data_in,Data_out,num_d, step_d, vec_reg(17:22),...
    smooth_out,smooth_in,false);

% Save data 
Tests=[Test1,Test2];
path_file = fullfile(your_folder,'model2_HV_D.mat'); % Data file name
save(path_file,'Tests')
%}
%% Prediction model 2  input  : ospedalizzati, vacinated_1d ; output : deceduti 
%{
% Try to predict the number of dead w.r.t
% the numbers of vaccinated (first dose) people and hospitalized. 
% Expected : t_norm = 30

% Moving window to create data
num_d=150;
step_d=100;

% Smooth (or not) the data
smooth_in=false;
smooth_out=true;

% Data selected (change the days of beginning and ending)
% Attention : for vaccination data use Days_vac, others use Days_cov !
vec_reg = 1:1:22;
% scenario origi
Data_in = create_data({vaccinated_1d(:,find(Days_cov=='01-Mar-2020'):...
    find(Days_cov=='20-Jan-2022')),tot_hospi(:,find(Days_cov=='01-Mar-2020'):...
    find(Days_cov=='20-Jan-2022'))},pop_reg,false);

Data_out = create_data({dead(:,find(Days_cov=='01-Mar-2020'):...
    find(Days_cov=='20-Jan-2022'))},pop_reg,true);
%%
num_c =find(Days_cov=='01-Sep-2021')-find(Days_cov=='01-Mar-2020')+1;
[Data_in,Data_out] = remove_days(Data_in,Data_out,22,num_c);
%%
[Tests,l1]=create_dataset(Data_in,Data_out,num_d, step_d, vec_reg,...
    smooth_out,smooth_in,true);
% Save data 
path_file = fullfile(your_folder,'scenario_org2.mat'); % Data file name
save(path_file,'Tests')


%}
