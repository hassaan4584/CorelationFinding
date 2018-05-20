% % 
% % 
fprintf('\n Reading Training Data\n')
% trainPath='./rvl-sorted-small/754x1000/100/Train';
trainPath='/Volumes/Parhai/Parhai/LUMS/Semester 4 Spring18/Thesis 2/Datasets/AI/Train/';

trainFolderContents = dir(trainPath);
count = size(trainFolderContents);
trainClasses = cell(5, 1);

% Reading class names
for i = 3:count(1)
   if trainFolderContents(i, 1).isdir == 1
       trainClasses{i, 1} = trainFolderContents(i, 1).name;
   end
end 

imageShape = [1000, 754];
% imageShape = [1000, 762];

TrainImageSizes = cell(1, 1);
% % %  Reading Train Data
Train = cell(50, 2);
trainImagesCount=0;

for i = 3:count(1)
    if trainFolderContents(i, 1).isdir == 1 
        trainClasses{i, 1} = trainFolderContents(i, 1).name;
        classPath = strcat(trainPath, '/', trainClasses{i, 1});
        classContents = dir(classPath);
        imageCount = size(classContents);
        for j = 1:imageCount(1)
            if classContents(j, 1).isdir == 0  && (strcmp(classContents(j, 1).name, '.DS_Store')== 0)
                trainImageName = classContents(j, 1).name;
                imagePath = strcat(classPath, '/', trainImageName);
                try
                    temp = imread(char(imagePath));
                    temp = rgb2gray(temp);
                    image_shape = size(temp);
%                     if image_shape(1) == imageShape(1) && image_shape(2) == imageShape(2)
                        trainImagesCount = trainImagesCount + 1;

                        Train{trainImagesCount, 1} = temp;
                        Train{trainImagesCount, 2} = trainClasses{i, 1};

                        TrainImageSizes {trainImagesCount, 1} = image_shape(1);
                        TrainImageSizes {trainImagesCount, 2} = image_shape(2);
                        
%                     end
                catch
                    fprintf('j=%i, imagePath=%s , \n', j, imagePath)
                end
           end
       end
   end
end



fprintf('\n Reading Test Data\n')

% testPath='./rvl-sorted-small/754x1000/100/Test';
testPath='/Volumes/Parhai/Parhai/LUMS/Semester 4 Spring18/Thesis 2/Datasets/AI/Test/';
testFolderContents = dir(testPath);
testCount = size(testFolderContents);
testClasses = cell(5, 1);

% % % Reading class names
for i = 3:testCount(1)
   if testFolderContents(i, 1).isdir == 1
       testClasses{i, 1} = testFolderContents(i, 1).name;
   end
end

Test = cell(1, 2);
testImagesCount=0;

for i = 3:testCount(1)
    if testFolderContents(i, 1).isdir == 1 
        testClasses{i, 1} = testFolderContents(i, 1).name;
        testClassPath = strcat(testPath, '/', testClasses{i, 1});
        testClassContents = dir(testClassPath);
        imageCount = size(testClassContents);
        imagesInFolder = imageCount(1);
%         imagesInFolder = 2+500;
        for j = 3:imagesInFolder
            if testClassContents(j, 1).isdir == 0 && (strcmp(classContents(j, 1).name, '.DS_Store')== 0)
                imageName = testClassContents(j, 1).name;
                imagePath = strcat(testClassPath, '/', imageName);
                try
                    temp = imread(char(imagePath));
                    temp = rgb2gray(temp);
                    image_shape = size(temp);
                    
    %                 if image_shape(1) == imageShape(1) && image_shape(2) == imageShape(2)
                        testImagesCount = testImagesCount + 1;
                        Test{testImagesCount, 1} = temp;
                        Test{testImagesCount, 2} = testClasses{i, 1};
    %                 end
                catch
                    fprintf('j=%i, imagePath=%s , \n', j, imagePath)
                end                    
           end
        end
   end
end


fprintf('\n Calculating Corelation Matrix\n')
TestCor = eye(1, 1);
for i = 1:testImagesCount
   for j = 1:trainImagesCount
       TestCor(i, j) = corr2(Test{i, 1}, Train{j, 1});
    
   end    
end


[A, OriginalTrainingOrder] = sort(TestCor, 2, 'descend');
Result = cell(testImagesCount, 2);
correctlyPredicted = 0;
for i = 1:testImagesCount
    Result(i, 1) = Test(i, 2);
    Result(i, 2) = Train(OriginalTrainingOrder(i, 1), 2);
    if strcmp(Result(i, 1), Result(i, 2)) == 1
       correctlyPredicted = correctlyPredicted + 1; 
    end
end

accuracy = (correctlyPredicted * 100) / testImagesCount;

fprintf('\n Accuracy = %.2f %%\n', accuracy);





%  Calculating Confusion Matrix
[resultCount, columnCount] = size(Result);
% ConfusionMatrix = cell(3, 3);
ConfusionMatrix = {0,0,0 ; 0,0,0 ; 0,0,0};

row=0;
col=0;
for i = 1:resultCount
    if strcmp(Result{i,1}, 'WS6')
        row = 1;
    elseif strcmp(Result{i,1}, 'WS7')
        row = 2;
    elseif strcmp(Result{i,1}, 'WS8')
        row = 3;
    end
    if strcmp(Result{i,2}, 'WS6')
        col = 1;
    elseif strcmp(Result{i,2}, 'WS7')
        col = 2;
    elseif strcmp(Result{i,2}, 'WS8')
        col = 3;
    end
   
    ConfusionMatrix{row, col} = ConfusionMatrix{row, col} + 1;
end
    ConfusionMatrix
% 





