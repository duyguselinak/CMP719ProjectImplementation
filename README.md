# CMP719ProjectImplementation
This project includes the implementation of the LIM model mentioned in the article "Towards Real-world X-ray Security Inspection: A High-Quality Benchmark And Lateral Inhibition Module For Prohibited Items Detection" as part of the course project. You can access to the article from this link: [link](https://arxiv.org/pdf/2108.09917.pdf)
Project developers; 
Duygu Selin AK 
Ozan YALÇIN

All of our work was carried out in the MatlabR2022b version. Image Processing Toolbox and Deep Network Designer must be installed in order to compile the codes. Each of the codes must be opened and run in the Matlab environment.

Script to translate the annotations in the dataset into English;
cat_ch_en.m

In order for the annotations in the dataset to be input for SSD and YOLO, tables called Train Tables must be created before the methods are run. The code fragments that create these tables for SSD and YOLO are given below, respectively.
SSD: generateTablesSSD.m
YOLO: generateTables.m


The scripts to be used for SSD+LIM, SSD, and YOLO training are given below, respectively.
SSD+LIM: buildCustomSSD.m
SSD: implement_ssd.m
YOLO: implement_yolo.m

Script to be used for sending test data by methods for estimation;
tester.m
