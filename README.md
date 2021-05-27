# Table of Contents
1. [file_generator.R](file_generator.R) contains the source code to generate 1,000 indepdent dataset used in the simulation. Each dataset is then converted to the correct format for each software.
2. [mplus_paralle.R](mplus_parallel.R) contains the source code to run Mplus parallel via R. It first gnerates the desired Mplus input files using [mplus_model.txt](mplus_model.txt). 
3. [sas_parallel.sas](sas_parallel.sas) contains the code to run SAS in parallel using macro [sas_macro.sas](sas_macro.sas).
4. [lcmm_parallel.R](lcmm_parallel.R) contains the code to run lcmm in parallel in R.
