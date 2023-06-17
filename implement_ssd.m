clear all;
clc;

train = true; %Train mode activation
collect_data = false; %Collect Data

%If train mode true and there are the tables in project path
%Load the tables

if train == true
    if isfile('TrainTable.mat')
        collect_data = true;
        load("TrainTable.mat");
        load("blds.mat");
        load("ds.mat");
        load("imds.mat");
    else
        %Otherwise, data couldnt be collected
        collect_data = false;
    end
end

train_path = 'C:\Users\yalci\Desktop\ImplementatioN\Fm\train\'; %Training DatasetPath
test_path = 'C:\Users\yalci\Desktop\ImplementatioN\Fm\test\'; %Test DatasetPath
train_im_files = dir(fullfile (train_path,'*.jpg'));  %List all image files
NoTrIm = length(train_im_files); %Get Number of image files

train_ann_files = dir(fullfile (train_path,'*.txt'));
NoTrAnn = length(train_ann_files);
test_ann_files = dir(fullfile (test_path,'*.txt'));
NoTeAnn = length(test_ann_files);


%Class and Category Names
HiXray_Classes = ["Portable_Charger_1", "Portable_Charger_2", "Water",  "Laptop", "Mobile_Phone" "Tablet", "Cosmetic", "Nonmetallic_Lighter"];
HiXray_Classes_Sh = ["PO1", "PO2", "WA",  "LA", "MP" "TA", "CO", "NL"];


%If there is no table
%Build the tables.
if collect_data == false
    imds = imageDatastore(train_path,"FileExtensions", ".jpg");
    [TrainTable,blds,ds] = generateTablesSSD(train_ann_files,imds);  
end

pause(2);


%If train mode is true
%Start tarining
if train==true
    traintestOpt = true;
    [customSSDNet,detNetworkSource] = buildCustomSSD(traintestOpt); %Build Custom SSD
    
    pause(2);
    inputSize = [300, 300, 3];

    %Generating the Anchor boxes for the dataset
    numAnchors = 9;
    [anchors,meanIoU] = estimateAnchorBoxes(blds,numAnchors);
    area = anchors(:, 1).*anchors(:,2);
    [~,idx] = sort(area,"descend");
    anchors = anchors(idx,:);
    anchorBoxes = {anchors(1:3,:)
        anchors(4:6,:)
        anchors(7:9,:)
        };

    %Generate and initialize the SSD detector
    detector = ssdObjectDetector(customSSDNet,HiXray_Classes_Sh,anchorBoxes,DetectionNetworkSource=detNetworkSource,InputSize=inputSize); 
    
    %Hyperparameters for YOLO detector
    options = trainingOptions('sgdm', ...
        momentum=0.9, ...
        InitialLearnRate=0.00001,...
        MiniBatchSize = 8, ....
        LearnRateSchedule = 'piecewise', ...
        MaxEpochs = 2, ...
        VerboseFrequency = 10, ...        
        CheckpointPath = tempdir, ...
        BatchNormalizationStatistics="moving",...
        Shuffle = 'every-epoch', ...
        Plots="training-progress");

    %Start Trainig
    [detector,info] = trainSSDObjectDetector(ds,detector,options);
end

