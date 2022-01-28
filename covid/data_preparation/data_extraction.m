%% ============= Data extraction =============

%%% Description %%%
%{

This file allows to extract data from the files which are possible to find
on the following website :
- https://github.com/pcm-dpc/COVID-19/blob/master/dati-andamento-covid19-italia.md
- https://github.com/italia/covid19-opendata-vaccini/tree/master/dati

The main idea is to select different data from regions or from the country
(Italy) in order to learn the equivalent of a SUHITER model by machine
learning.

The work accomplished so far considers only hospitalized, dead
and vaccinated with the first dose. But the results could be improved with other
considerations which are very easy to add.
%}

close all
clear

%% Files & Folders path (precise owner folder) :

your_folder = '/Users/model_learning/examples/covid/data_preparation';

path_file = fullfile(your_folder,'Dati_covid_vac.mat'); % Data file name

%% Explanations for using Data_regioni (array)
%{
% According to the website the following data are accessible
Data_regioni(:,i) i = 1 : 11 ;
1  - ricoverati_con_sintomi    
2  - terapia_intensiva    
3  - totale_ospedalizzati    
4  - isolamento_domiciliare    
5  - totale_positivi    
6  - variazione_totale_positivi    
7  - nuovi_positivi    
8  - dimessi_guariti    
9  - deceduti
10 - totale_casi   
11 - tamponi

Good to know if you transform one column of the table to an array you have 
the regions in this order :

1  - Abruzzo
2  - Basilicata
3  - Calabria
4  - Campania
5  - Emilia-Romagna
6  - Friuli Venezia Giulia
7  - Lazio
8  - Liguria
9  - Lombardia
10 - Marche
11 - Molise
12 - P.A. Bolzano
13 - P.A. Trento
14 - Piemonte
15 - Puglia
16 - Sardegna
17 - Sicilia
18 - Toscana
19 - Umbria
20 - Valle d'Aosta
21 - Veneto

Pay attention the file from the website for vaccine data orders the
regions with respect to the ISTAT number and the corresponding sequence is :

Istat = [13 17 18 15 8 6 12 7 3 11 14 21 4 1 16 20 19 9 10 2 5] (for the previous list)

The region of Trentino-Alto Adige is split into the two auntonomous provinces Bolzano and Trento.
The Istat 21 is given to Bolzano and 4 is kept for Trento (normally they have the same). 
When vaccine data are extracted Bolzano has to be dealt carefully.


%% Example : 
% Number total of days  : length(Data_regioni)/number_regions
% Deceduti (9) di Toscana (18) :  
for i = 0 : length(Data_regioni)/(number_regions - 1)
    deceduti_tosc(i)=Data_regioni(18 + i*number_regions)
end
%}
%% Regions (name, population, Istat)

names = ['Abruzzo' 'Basilicata' 'Calabria' 'Campania' 'Emilia-Romagna'...
    'Friuli Venezia Giulia' 'Lazio' 'Liguria' 'Lombardia' 'Marche' 'Molise'...
    'P.A. Bolzano' 'P.A. Trento' 'Piemonte' 'Puglia' 'Sardegna' 'Sicilia'...
    'Toscana' 'Umbria' "Valle d'Aosta" 'Veneto' 'Italy'];

Istat = [13 17 18 15 8 6 12 7 3 11 14 21 4 1 16 20 19 9 10 2 5];

% Population in each region (2020-2021)
pop_reg = [1.3E6 5.6E5 1.92E6 5.79E6 4.47E6 1.2E6 5.87E6 1.54E6 1E7 ...
           1.52E6 3.02E5 1.075E5/2 1.075E5/2 4.34E6 4.01E6 1.63E6 4.97E6 ...
           3.72E6 8.80E6 1.26E5 4.91E6];

pop_tot=sum(pop_reg); % National scale

pop_reg=[pop_reg,pop_tot]';
%% Extract data from .csv

%%%% 1- Covid data %%%
%{
Every file can be upload thanks to the new daily version on the website
cf description.
%}

% Italy 
% (put the file in the main folder ie : examples/covid/data_preparation)
name_file ='dpc-covid19-ita-andamento-nazionale.csv';
Table_it = readtable(name_file);
Data_it = [table2array(Table_it(:,3:11)) table2array(Table_it(:,14:15))];

% Regioni 
% (put the file in the main folder ie : examples/covid/data_preparation)
name_file ='dpc-covid19-ita-regioni.csv';
Table_cov = readtable(name_file);
Data_regioni = [table2array(Table_cov(:,7:15)) table2array(Table_cov(:,18:19))];

% Days vectors (time is needed for the training)
Days_cov = table2array(Table_it(:,1));
len = length(Days_cov);
for ii=1:len
    dd=split(Days_cov(ii),'T');
    Days_cov(ii)=dd(1);
end
Days_cov=datetime(Days_cov,'InputFormat','uuuu-MM-dd');


% Categories of people (similar to SUIHTER model)

ricoverati_con_sintomi = zeros(22,len); 
tera_intensive = zeros(22,len);  
tot_hospi = zeros(22,len);   
isolamenti = zeros(22,len);    
tot_pos = zeros(22,len);   
var_tot_pos = zeros(22,len);     
new_pos = zeros(22,len);     
dimessi_guariti = zeros(22,len);     
dead = zeros(22,len); 
tot_case  = zeros(22,len);  
test  = zeros(22,len); 

for day = 1 : len 
    for regi = 1 : 22
        
        if regi == 22 % Italy 
            if day == 1
                dead(regi,day) = Data_it(day,9); 
            else
                dead(regi,day) = Data_it(day,9)-Data_it(day-1,9); 
            end
            ricoverati_con_sintomi(regi,day) = Data_it(day,1); 
            tera_intensive(regi,day) = Data_it(day,2);
            tot_hospi(regi,day) = Data_it(day,3);   
            isolamenti(regi,day) = Data_it(day,4);    
            tot_pos(regi,day) = Data_it(day,5);   
            var_tot_pos(regi,day) = Data_it(day,6);     
            new_pos(regi,day) = Data_it(day,7);     
            dimessi_guariti(regi,day) = Data_it(day,8);      
            tot_case(regi,day) = Data_it(day,10);  
            test(regi,day) = Data_it(day,11); 
       
        else % any region
            if day == 1
                dead(regi,day) = Data_regioni(21*(day-1)+regi,9); 
            else
                dead(regi,day) = Data_regioni(21*(day-1)+regi,9)-...
                    Data_regioni(21*(day-2)+regi,9); 
            end
            ricoverati_con_sintomi(regi,day) = Data_regioni(21*(day-1)+regi,1); 
            tera_intensive(regi,day) = Data_regioni(21*(day-1)+regi,2);
            tot_hospi(regi,day) = Data_regioni(21*(day-1)+regi,3);   
            isolamenti(regi,day) = Data_regioni(21*(day-1)+regi,4);    
            tot_pos(regi,day) = Data_regioni(21*(day-1)+regi,5);   
            var_tot_pos(regi,day) = Data_regioni(21*(day-1)+regi,6);     
            new_pos(regi,day) = Data_regioni(21*(day-1)+regi,7);     
            dimessi_guariti(regi,day) = Data_regioni(21*(day-1)+regi,8);     
            tot_case(regi,day) = Data_regioni(21*(day-1)+regi,10);  
            test(regi,day) = Data_regioni(21*(day-1)+regi,11); 
        end

    end
end

%% 2- Vaccinated %%
%{
A cumulative version for the vaccine is chosen because the number of
vaccinated in total seems to be more important that the number of daily
vaccinated.
%}
% Vaccinations
% (put the file in the main folder ie : examples/covid/data_preparation)
name_file ='somministrazioni-vaccini-latest.csv';
Table_vac = readtable(name_file);

Dates_vac = table2array(Table_vac(:,1));
Days_vac= unique(Dates_vac);
len_vac = length(Days_vac);

Data_vaccineti = [table2array(Table_vac(:,7:8)) table2array(Table_vac(:,10)) table2array(Table_vac(:,13))];
%%
vaccinated_1d=zeros(22,len);
vaccinated_2d=zeros(22,len);
vaccinated_3d=zeros(22,len);

iter=1;
for day = 1 : len_vac
    dday=day+(len-len_vac);
    while (iter<=length(Dates_vac)) && (Days_vac(day)==Dates_vac(iter))
        
        if (Data_vaccineti(iter,4)==4) && ...
                (strcmp(table2array(Table_vac(iter,14)),'Provincia Autonoma Bolzano / Bozen'))
            vaccinated_1d(12,dday)=vaccinated_1d(12,dday)+...
                Data_vaccineti(iter,1);
            vaccinated_2d(12,dday)=vaccinated_2d(12,dday)+...
                Data_vaccineti(iter,2);
            vaccinated_3d(12,dday)=vaccinated_3d(12,dday)+...
                Data_vaccineti(iter,3);
            
            
        else  
            reg=find(Istat==Data_vaccineti(iter,4));
            vaccinated_1d(reg,dday)=vaccinated_1d(reg,dday)+...
                Data_vaccineti(iter,1);
            vaccinated_2d(reg,dday)=vaccinated_2d(reg,dday)+...
                Data_vaccineti(iter,2);
            vaccinated_3d(reg,dday)=vaccinated_3d(reg,dday)+...
                Data_vaccineti(iter,3);
        end
        iter=iter+1;
    end
    if day>1 
        vaccinated_1d(:,dday) = vaccinated_1d(:,dday) + vaccinated_1d(:,dday-1);
        vaccinated_2d(:,dday) = vaccinated_2d(:,dday) + vaccinated_2d(:,dday-1);
        vaccinated_3d(:,dday) = vaccinated_3d(:,dday) + vaccinated_3d(:,dday-1);
    end
end

% Compute national vaccination

for day = 1 : len
    vaccinated_1d(22,day)=sum(vaccinated_1d(1:21,day));
    vaccinated_2d(22,day)=sum(vaccinated_2d(1:21,day));
    vaccinated_3d(22,day)=sum(vaccinated_3d(1:21,day));
end

%% 3 - Parameter R 

% R* computed with the article
l=log(tot_pos);
l(:,1:end-6)=((l(:,7:end)-l(:,1:end-6))/7+1/9)*9;

for ii=1:5
    l(:,end-ii)=((l(:,end)-l(:,end-ii))/ii+1/9)*9;
end
l(:,end)=l(:,end-1)+(l(:,end-1)-l(:,end-2));
R_star=l;
%% Rstar_mox 

name_file2 ='Rstar_it.csv';
Table_rmox = readtable(name_file);
Days_mox = table2array(Table_rmox(:,1));
R_it = table2array(Table_rmox(:,2));
Rmox_it=zeros(1,length(Days_mox));
for jj=1:length(Days_mox)
    val = R_it(jj);
    Rmox_it(jj)=str2double(val{1});
end

%{
figure(32)
hold on
title('$R_{*}$ for Italy','Interpreter','latex')
plot(Days_mox,Rmox_it,'-.')
plot(Days_mox,R_star(22,1:length(Days_mox)),'-')
xlabel('Days','Interpreter','latex')
ylabel('$R_{*}$','Interpreter','latex')
legend('R_{mox}','R_{star}')
%}



%% Save all the data computed
save(path_file,'ricoverati_con_sintomi','tera_intensive', 'tot_hospi',...
    'isolamenti', 'tot_pos',  'var_tot_pos', 'new_pos','dimessi_guariti',...     
    'dead','tot_case','test','pop_reg','Days_cov','Days_vac',...
    'vaccinated_1d','vaccinated_2d','vaccinated_3d','names','R_star','Rmox_it',...
    'Days_mox');
     


