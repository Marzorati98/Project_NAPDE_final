%% Fixed randomicity to reproduce experience
clear 
close all 
stream = RandStream('dsfmt19937','Seed',3);

%% ============= 1 - Load problem - =============
%% Define the problem 
% Important to check all the parameters in '.ini' file before to run

problem1 = problem_get('covid','COV.ini');
problem2 = problem_get('covid','COV2.ini');

%% Load Data and models

load('scenario_org2','Tests')
dataset_save(problem2 ,Tests,'sc_org2.mat')
for i =1 :length(Tests)
Tests{i}.uu(1,:)=zeros(1,length(Tests{i}));
end
dataset_save(problem2 ,Tests,'sc_nul2.mat')

for i =1 :length(Tests)
Tests{i}.uu(1,:)=[];
end
dataset_save(problem1 ,Tests,'sc_org1.mat')


%1)a)
learned_model_name = 'model_hos_D_a_int_N1_hlayF1_dof5_ntrain208_2022-01-23_19-40-01'; 
% write here the model name 
ANNmod1_a = read_model_fromfile(problem1,learned_model_name);
%1)b)
learned_model_name = 'model_hos_D_b_int_N1_hlayF2_dof9_ntrain208_2022-01-23_19-59-45'; 
% write here the model name 
ANNmod1_b = read_model_fromfile(problem1,learned_model_name);

%2)a)
learned_model_name = 'model_H_v1_D_a_int_N1_hlayF1_dof6_ntrain208_2022-01-23_21-34-08'; 
%write here the model name 
ANNmod2_a = read_model_fromfile(problem2,learned_model_name);
%2)b)
learned_model_name = 'model_H_v1_D_b_int_N1_hlayF2_dof11_ntrain208_2022-01-23_21-44-46'; 
%write here the model name 
ANNmod2_b = read_model_fromfile(problem2,learned_model_name);


%% Error evaluation
%Error is computed for each region (for each network)
close all

% Model 1_a without vaccin

dataset_def.problem = problem1;
dataset_def.type = 'file';
error_1_a=zeros(1,22);
for i =1:22
   dataset_def.source = 'sc_org1.mat;['+string(i)+':'+string(i)+']';
    test_dataset_1 = dataset_get(dataset_def);
    err2 = model_compute_error(ANNmod1_a, test_dataset_1); 
    error_1_a(i)=err2.err_dataset_L2;
    
end

dataset_def.source = 'sc_org1.mat;[1:22]';
test_dataset_1 = dataset_get(dataset_def);
output_1_a = model_solve(test_dataset_1,ANNmod1_a,struct('do_plot',0));

% Model 1_b without vaccin

dataset_def.problem = problem1;
dataset_def.type = 'file';
error_1_b=zeros(1,22);
for i =1:22
   dataset_def.source = 'sc_org1.mat;['+string(i)+':'+string(i)+']';
    test_dataset_1 = dataset_get(dataset_def);
    err2 = model_compute_error(ANNmod1_b, test_dataset_1); 
    error_1_b(i)=err2.err_dataset_L2;
end

dataset_def.source = 'sc_org1.mat;[1:22]';
test_dataset_1 = dataset_get(dataset_def);
output_1_b = model_solve(test_dataset_1,ANNmod1_b,struct('do_plot',0));

% Model 2_a 

dataset_def.problem = problem2;
dataset_def.type = 'file';
error_2_a=zeros(1,22);
for i =1:22
   dataset_def.source = 'sc_org2.mat;['+string(i)+':'+string(i)+']';
    test_dataset_2 = dataset_get(dataset_def);
    err2 = model_compute_error(ANNmod2_a, test_dataset_2); 
    error_2_a(i)=err2.err_dataset_L2;
    
end
dataset_def.source = 'sc_org2.mat;[1:22]';
test_dataset_2 = dataset_get(dataset_def);
output_2_a = model_solve(test_dataset_2,ANNmod2_a,struct('do_plot',0));

% Model 2_b 

dataset_def.problem = problem2;
dataset_def.type = 'file';
error_2_b=zeros(1,22);
for i =1:22
   dataset_def.source = 'sc_org2.mat;['+string(i)+':'+string(i)+']';
    test_dataset_2 = dataset_get(dataset_def);
    err2 = model_compute_error(ANNmod2_b, test_dataset_2); 
    error_2_b(i)=err2.err_dataset_L2;
    
end

dataset_def.source = 'sc_org2.mat;[1:22]';
test_dataset_2 = dataset_get(dataset_def);
output_2_b = model_solve(test_dataset_2,ANNmod2_b,struct('do_plot',0));
%% mean error to select the best result
mean(error_1_a)
mean(error_1_b)
mean(error_2_a)
mean(error_2_b)

%% Plot the error
names = {'Abruzzo' ;'Basilicata'; 'Calabria'; 'Campania' ;'Emilia-Romagna';...
    'Friuli Venezia Giulia' ;'Lazio' ;'Liguria'; 'Lombardia' ;'Marche' ;...
    'Molise';'P.A. Bolzano';'P.A. Trento'; 'Piemonte' ;'Puglia'; 'Sardegna';...
    'Sicilia';'Toscana' ;'Umbria' ;"Valle d'Aosta" ;'Veneto' ;'Italy'};
figure()
plot(1:22,error_1_a,'+')
hold on
plot(1:22,error_1_b,'*')
plot(1:22,error_2_a,'o')
plot(1:22,error_2_b,'^')
grid ON
ylabel('error L_2')
set(gca,'xtick',1:22,'xticklabel',names)
xtickangle(45)
legend('Mod1_a','Mod1_b','Mod2_a','Mod2_b')
set(findall(gcf,'-property','FontSize'),'FontSize',20)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2.5)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',12)
%% Prediction over a scenario

% Scenario without vaccin
dataset_def.source = 'sc_nul2.mat;[1:22]';
test_dataset_3 = dataset_get(dataset_def);
output_3 = model_solve(test_dataset_3,ANNmod2_b,struct('do_plot',0));


%% Plot the different results
%Here for Lazio, Lombardy, Trento and Italy
regs=[7 9 13 22];

for reg=regs

figure()

%Input data
subplot(2,2,1)
plot(output_2_a{reg}.tt,output_2_a{reg}.uu,'-','linewidth',1.2)
axis([0 output_1_a{1,1}.tt(end) min(ANNmod1_a.problem.u_min) max(ANNmod1_a.problem.u_max)])
ylabel('u')
legend('Vacinnated','Hospitalized')
grid ON

% Results models type 1 vs real values
subplot(2,2,2)
plot(output_1_a{reg}.tt_y,output_1_a{reg}.yy,'-.','linewidth',1.2) 
hold on
plot(output_1_b{reg}.tt_y,output_1_b{reg}.yy,'--','linewidth',1.2) 
plot(test_dataset_1{reg}.tt,test_dataset_1{reg}.yy,'-','linewidth',1.2)
axis([0 output_1_a{1,1}.tt(end) min(ANNmod1_a.problem.y_min) max(ANNmod1_a.problem.y_max)])
legend('test model 1_a','test model 1_b','HF model')
hold off
ylabel('y')
grid ON

% Results models type 2 vs real values
subplot(2,2,3)
plot(output_2_a{reg}.tt_y,output_2_a{reg}.yy,'--','linewidth',1.2) 
hold on
plot(output_2_b{reg}.tt_y,output_2_b{reg}.yy,'--','linewidth',1.2) 
plot(test_dataset_1{reg}.tt,test_dataset_1{reg}.yy,'-','linewidth',1.2)
axis([0 output_1_a{1,1}.tt(end) min(ANNmod1_a.problem.y_min) max(ANNmod1_a.problem.y_max)])
legend('test model 2_a','test model 2_b','HF model')
hold off
ylabel('y')
grid ON

% Best model type 2 : scenario vs reality
subplot(2,2,4)
plot(output_2_b{reg}.tt_y,output_2_b{reg}.yy,'--','linewidth',1.2) 
axis([0 output_1_a{1,1}.tt(end) min(ANNmod1_a.problem.y_min) max(ANNmod1_a.problem.y_max)])
hold on
plot(output_3{reg}.tt_y,output_3{reg}.yy,'-.','linewidth',1.2) 
legend('test model 2_b','scenario without vaccine')
hold off
ylabel('y')
grid ON
set(findall(gcf,'-property','FontSize'),'FontSize',20)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2.5)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',12)


end
