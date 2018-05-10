# injectControl
Repository contains scripts and documentation to help diabetics who inject.  

They make use of openAPS resources, both code and design.  They require a continuous glucose meter (CGM) 
and a Linux computer.

The departures from openAPS are: 
(1) not using 'Nightscout', 
(2) using Mongodb to store CGM data **locally**, 
(3) **not** using an insulin pump and associated records,
(4) entering insulin and carbohydrates using your Dexcom CGM,
(5) equating slow-acting insulin (especially Lantus(tm)) with openAPS' "basal".

Here is a roadmap of planned scripts and documentation:
(1) commands to set up open on your Linux computer, even though you have no insulin pump;
(2) setting up mongodb (database manager) for local use with your CGM;
(3) recording insulin injections and carbohydrate consumption with your Dexcom G4 CGM;
(4) uploading CGM data to mongodb on your Linux computer;
(5) script(s) for summarizing uploaded data;
(6) preparing openAPS 'profile' information for use with uploaded data;
(7) running openAPS tuning applications using profile and uploaded data;
(8) plotting and analyzing uploaded data, and beyond.  (work in progress).

