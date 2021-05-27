%macro traj_analysis(index=,length=);
%do i= &index %to (&index+&length);
PROC IMPORT DATAFILE= "dat&i..csv"
OUT= Work.dart&i
DBMS=csv REPLACE;
GETNAMES=YES;
DATAROW=2; 
RUN;
%let _timer_start = %sysfunc(datetime());
PROC TRAJ DATA=Dart&i OUTEST = OE&i;
ID VAR1;
VAR  _1-_12;
INDEP V1-V12;
RISK cova covb covc;
MODEL ZIP;
NGROUPS 4; /* This can be changed accordingly*/
ORDER 1 1 1 1; /* This can be changed accordingly*/
IORDER 1 1 1 1; /* This can be changed accordingly*/
RUN;
%if &i.=1 %then %do;
  data out;
    set oe&i.;
	iter = &i+&index-1;
	dur = datetime() - &_timer_start;
	by _BIC1_;
    if first._BIC1_;
    keep iter dur _BIC1_;
  run;
%end;
%else %do;
data out2;
set oe&i.;
iter = &i+&index-1;
dur = datetime() - &_timer_start;
by _BIC1_;
if first._BIC1_;
keep iter dur _BIC1_;
run;
proc append data=out2 base=out; run;
%end;
%end;
%mend;
