clear all;
clc;

%Paths of the HiXray dataset for train and Test
dataset_path = 'C:\Users\yalci\Desktop\ImplementatioN\Fm\datasets\';
train_path = 'C:\Users\yalci\Desktop\ImplementatioN\Fm\datasets\train\';
test_path = 'C:\Users\yalci\Desktop\ImplementatioN\Fm\datasets\test\';
reduced_train = 'C:\Users\yalci\Desktop\ImplementatioN\Fm\train\';
reduced_test = 'C:\Users\yalci\Desktop\ImplementatioN\Fm\test\';

train_im_files = dir(fullfile (train_path,'*.jpg')); %List all image files
NoTrIm = length(train_im_files); %Get Number of image files

train_ann_files = dir(fullfile (train_path,'*.txt')); %List all annotation files
NoTrAnn = length(train_ann_files); %Get Number of image files

test_im_files = dir(fullfile (test_path,'*.jpg')); %List all image files
NoTeIm = length(test_im_files); %Get Number of image files

test_ann_files = dir(fullfile (test_path,'*.txt')); %List all annotation files
NoTeAnn = length(test_ann_files); %Get Number of image files

cd 'C:\Users\yalci\Desktop\ImplementatioN\Fm\datasets\train\';
disp("OK");
pause(10); %Waiting 10 sec to access the path

%Generating train table
imdsTrain = imageDatastore(train_path,"FileExtensions", ".jpg");
[TrainTable,blds1,ds1] = generateTables(train_ann_files,imdsTrain); 

cd 'C:\Users\yalci\Desktop\ImplementatioN\Fm\datasets\test\';
disp("OK");
pause(10); %Waiting 10 sec to access the path
%Generating test table
imdsTest = imageDatastore(test_path,"FileExtensions", ".jpg");
[TestTable,blds2,ds2] = generateTables(test_ann_files,imdsTest);

size(blds1.LabelData,1) %Train
size(blds2.LabelData,1) %Test


%Below Loops create the sub-dataset
%Save all reduced train and test sub-dataset

for j=4:6
    cnt=1;
    for i=1:size(blds2.LabelData,1)
        if size(blds2.LabelData{i,2},1) == j
            testImcat (cnt) = TestTable.FileName(i);
            knmTest(cnt) = i;
            cnt=cnt+1;
        end
    end
    disp(cnt)
    
    pause(10);
    for i=1:size(knmTest,2) 
        nameAnn = test_ann_files(knmTest(i)).name;
        statusAnn = copyfile(nameAnn, reduced_test);
        nameIm = testImcat{i};
        statusIm = copyfile(nameIm, reduced_test);
    end    
end

cd 'C:\Users\yalci\Desktop\ImplementatioN\Fm\datasets\train\';
for j=4:6
    cnt=1;
    for i=1:size(blds1.LabelData,1)
        if size(blds1.LabelData{i,2},1) == j
            trainImcat (cnt) = TrainTable.FileName(i);
            knm(cnt) = i;
            cnt=cnt+1;
        end
    end
    disp(cnt)
    
    
    pause(10);
    for i=1:size(knm,2) 
        nameAnn = train_ann_files(knm(i)).name;
        statusAnn = copyfile(nameAnn, reduced_train);
        nameIm = trainImcat{i};
        statusIm = copyfile(nameIm, reduced_train);
    end    
end