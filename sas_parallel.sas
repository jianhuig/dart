options sascmd = "D:\SAS\SASFoundation\9.4\sas.exe -nosyntaxcheck"
autosignon;

rsubmit task1 wait = no;
     %traj_analysis3(index=1,length=124);
     run;
endrsubmit task1;

rsubmit task2 wait = no;
     %traj_analysis3(index=126,length=124);
     run;
endrsubmit task2;

rsubmit task3 wait = no;
     %traj_analysis3(index=251,length=124);
     run;
endrsubmit task3;

rsubmit task4 wait = no;
     %traj_analysis3(index=376,length=124);
     run;
endrsubmit task4;

rsubmit task5 wait = no;
     %traj_analysis3(index=501,length=124);
     run;
endrsubmit task5;

rsubmit task6 wait = no;
     %traj_analysis3(index=626,length=124);
     run;
endrsubmit task6;

rsubmit task7 wait = no;
     %traj_analysis3(index=751,length=124);
     run;
endrsubmit task7;

rsubmit task8 wait = no;
     %traj_analysis3(index=876,length=124);
     run;
endrsubmit task8;

waitfor _all_ task1 task2 task3 task4 task5 task6 task7 task8;
signoff _all_;
