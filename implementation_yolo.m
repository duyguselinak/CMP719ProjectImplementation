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
train_im_files = dir(fullfile (train_path,'*.jpg')); %List all image files
NoTrIm = length(train_im_files); %Get Number of image files

train_ann_files = dir(fullfile (train_path,'*.txt')); %List all annotation files
NoTrAnn = length(train_ann_files); %Get Number of annotation files

%Class and Category Names
HiXray_Classes = ["Portable_Charger_1", "Portable_Charger_2", "Water",  "Laptop", "Mobile_Phone" "Tablet", "Cosmetic", "Nonmetallic_Lighter"];
HiXray_Classes_Sh = ["PO1", "PO2", "WA",  "LA", "MP" "TA", "CO", "NL"];

%If there is no table
%Build the tables.
if collect_data == false
    imds = imageDatastore(train_path,"FileExtensions", ".jpg");
    [TrainTable,blds,ds] = generateTables(train_ann_files,imds);  
end

pause(2); %Pause 2 sec.

%If train mode is true
%Start tarining
if train == true
    inputSize = [320 320 3]; %Input image size for Network  
    numAnchors = 9; %Number of Anchor Boxes

    %Generating the Anchor boxes for the dataset
    [anchors,meanIoU] = estimateAnchorBoxes(blds,numAnchors);
    area = anchors(:, 1).*anchors(:,2);
    [~,idx] = sort(area,"descend");
    anchors = anchors(idx,:);
    anchorBoxes = {anchors(1:3,:)
        anchors(4:6,:)
        anchors(7:9,:)
        };
    
    %Generate and initialize the YOLO detector
    detector = yolov4ObjectDetector("csp-darknet53-coco",HiXray_Classes_Sh,anchorBoxes,InputSize=inputSize);
    
    %Hyperparameters for YOLO detector
    options = trainingOptions("sgdm",...
        InitialLearnRate=0.001,...
        MiniBatchSize=4,...
        MaxEpochs=5, ...
        Shuffle='every-epoch',...
        BatchNormalizationStatistics="moving",...
        ResetInputNormalization=false,...
        VerboseFrequency=20,...
        Plots="training-progress"...
        );
    
    %Start Trainig
    [detector,info] = trainYOLOv4ObjectDetector(ds,detector,options);

end
