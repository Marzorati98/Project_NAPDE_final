# Project 2021-2022 

Politecnico di Milano: NAPDE

Authors: Biafora Lucrezia, Marelli Alessandra, Marzorati Arsène

Professors: Dede Luca, Quarteroni Alfio, Regazzoni Francesco

Goal: The project is to apply the Matlab Library "Model Learning" to the Covid situation.

Link of the library "Model learning": https://github.com/FrancescoRegazzoni/model-learning.

## First step: Installation 
   * Download the 'Model learning' at the indicated address.
   * Download the folder covid and add it in the folder (:/Model_Learning/examples/)
   * To have the current data (covid in Italy) you can download the last files at the following links:
      + https://github.com/pcm-dpc/COVID-19/blob/master/dati-andamento-covid19-italia.md
      + https://github.com/italia/covid19-opendata-vaccini
         - The names of the files we used are the same on both website.
         - On the first website it could be difficult to download the data due to the huge number of files...
         - Add the files in the folder (:/Model_Learning/examples/data_preparation).
         - Here are already data from February 2020 to January 2021.
    
### Folder and its files

1) Folder data_preparation:
    * data_extraction: allows to extract data from the '.cvs files' (free access on internet).
    * data_transformation: allows to create data sets matching with the library.
        + create_data: Transform the matlab variable to data for the library.
        + create_dataset: function to create a data set with specific parameters.
        + remove_days: select a part of the tests created.

2) Folder covid
    * covid_training: allows to train network with tests created with previous files (and save the neural networks)
    * prediction: allows to use the trained network to evaluate on new data and try some predictions.
       + .ini: (eg: COV.ini) allows to define the problem (number of inputs and output, the extrema values...).
       + _opt.ini (eg: COV_opt.ini) allows to define all the parameters for the training (dataset, penalizations, number of iterations, structure of the ANN...).
       + Two examples are provided.
        
Remark: All the matlab files are written with many comments. Each step is very detailed inside the code (even the functions).

## How to procede ?
 
1) Extract the data with data_extraction (save it)
2) Choose the interesting data, the corresponding dates, the size times of your tests/scenarios as in the example in data_transformation and save them.
3) Train the ANN indicating the number of tests and the hyperparameters in ".ini" and "opt.ini" and run the training file.
4) If you have enough data (new ones) use the prediction file to estimate the error or compare scenarios.

## Bibliography
[1] F.Regazzoni, L.Dede’, and A.Quarteroni. Machine learning for fast and
reliable solution of time-dependent differential equations. (2019).

[2] Roberto Battiston. "Un modo semplice per calcolare r(t)." (2020).

[3] Politecnico di Milano MOX, Dipartimento di Matematica. epiMox website.
(2020-2022).



