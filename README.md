# injectControl
Repository contains scripts and documentation to help diabetics who inject.  

They make use of openAPS resources, both code and design.  They require a continuous glucose meter (CGM) 
and a Linux computer.

The departures from openAPS are: 
(1) not using 'Nightscout', 
(2) using Mongodb to store CGM data locally, 
(3) not using an insulin pump and associated records
(4) equating slow-acting insulin (espeically Lantus(tm) with openAPS' "basal")
