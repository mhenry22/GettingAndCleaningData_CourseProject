Here is the general codebook of my work. If needed, for more information, please don't hesitate to look inside the run_analysis.R code since I put detailed comments in each step of it.

## The run_analysis.R code generates the following data tables:

### dataset_folder
    - class = data.frame
    - dimensions = 32 x 3
    
### features
    - class = tbl_df, tbl, data.frame
    - dimensions = 561 x 2
    
### data_train
    - class = tbl_df, tbl, data.frame
    - dimensions = 7352 x 563

### data_test
    - class = tbl_df, tbl, data.frame
    - dimensions = 2947 x 563

### data_all
    - description = corresponds to the appending of data_train and data_test data tables
    - class = tbl_df, tbl, data.frame
    - dimensions = 10299 x 563

### data_mean_std
    - description = corresponds to data_all where we just kept features about mean and standard deviation and put those features in one column named measurement
    - class = tbl_df, tbl, data.frame
    - dimensions = 679734 x 5
    
### grouped_dataset
    - description = corresponds to the grouping of data_mean_std by subject, label, activity and measurement variables
    - class = grouped_df, tbl_df, tbl, data.frame
    - dimensions = 679734 x 5

### tidy_dataset
    - description = corresponds to the resulting final dataset where the average of the value variable is computed for each subject, label, activity combination
    - class = grouped_df, tbl_df, tbl, data.frame
    - dimensions = 11880 x 5

## Below are listed, in order, all the variables that appear in my tidy dataset, their class (which here stands for the unit) and some basic statistics about them.
This codebook was generated with the help of the codebook() function from the memisc package.
For further information on initial and intermediate data tables, in order not to overload this codebook, please use the codebook() function in RStudio applied to the previously listed relevant tables.

### subject

   Storage mode: integer

          Min.:   1.000
       1st Qu.:   8.000
        Median:  15.500
          Mean:  15.500
       3rd Qu.:  23.000
          Max.:  30.000

### activity

   Storage mode: character

       Length:      11880
        Class:  character
         Mode:  character

### measurement

   Storage mode: character

       Length:      11880
        Class:  character
         Mode:  character

### average

   Storage mode: double

          Min.:  -0.998
       1st Qu.:  -0.962
        Median:  -0.470
          Mean:  -0.484
       3rd Qu.:  -0.078
          Max.:   0.975
          
