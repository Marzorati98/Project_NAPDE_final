# Project 2021-2022 #

Politecnico di Milano: NAPDE

Authors: Biafora Lucrezia, Marelli Alessandra, Marzorati Arsène

Professors: Dede Luca, Quarteroni Alfio, Regazzoni Francesco

Goal: The project is to apply the Matlab Library "Model Learning" to the Covid situation.

Our files are in the folder Covid (:/Model_Learning/examples/covid)

1) Folder data_preparation:
    * data_extraction allows to extract data from the .cvs files (free access on internet).
    * data_transformation allows to create data sets matching with the library.
        + create_data: Transform the matlab variable to data for the library
        + create_dataset: function to create a data set with specific parameters
        + remove_days: select a part of the tests created.

2) Folder covid
    * covid_training allows to train network with tests created with previous files
    * prediction allows to use the trained network to evaluate on new data and try some predictions.
        

# How to procede ?
 
1- Download the files from the covid data (links precised in data_extraction).
Here are already data from september 2020 to January 2021.
2- Extract the data with data_extraction (save it)
3- Choose the data, the dates, the size times of your tests/scenarios as in the example in data_transformation (save them)
4- Train the networks indicating the number of test, the hyperparameters in ".ini" and "_opt.ini" (again the examples are 
very described)
5- If you have enough data or ideas use the prediction file to estimate the error or compare scenarios.

