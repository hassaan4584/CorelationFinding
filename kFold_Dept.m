fprintf('\n Reading All Data\n')
allDataPath='/Volumes/Parhai/Parhai/LUMS/Semester 4 Spring18/Thesis 2/Datasets/Dept-kFold/';

allDataFolderContents = dir(allDataPath);
count = size(allDataFolderContents);
allDataClasses = cell(0, 0);

% Reading class names
numberOfClasses = 0;
for i = 1:count(1)
   if allDataFolderContents(i, 1).isdir == 1 && (strcmp(allDataFolderContents(i, 1).name, '.')== 0)
       if (strcmp(allDataFolderContents(i, 1).name, '..')== 0)
            numberOfClasses = numberOfClasses+1;
            allDataClasses{numberOfClasses, 1} = allDataFolderContents(i, 1).name;
       end
   end
end 


imageShape = [3696, 2574];
TrainImageSizes = cell(0, 0);
% % %  Reading Data 
Data = cell(0, 0);
totalImagesCount=0;

% Open and Read Images
for i = 1:numberOfClasses
    classPath = strcat(allDataPath, '/', allDataClasses{i, 1});
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
                if image_shape(1) == imageShape(1) && image_shape(2) == imageShape(2)
                    totalImagesCount = totalImagesCount + 1;
                    Data{totalImagesCount, 1} = temp;
                    Data{totalImagesCount, 2} = allDataClasses{i, 1};
                    Data{totalImagesCount, 3} = trainImageName;

                end
            catch
                fprintf('j=%i, imagePath=%s , \n', j, imagePath)
            end
       end
   end
end

randomSequence = randperm(totalImagesCount)';
NewData = cell(0, 0);
for i=1: totalImagesCount
    j = randomSequence(i);
    NewData(j, :) = Data(i, :);
end


K = 5;
batcheSize = int32(totalImagesCount/K);

Train = NewData;
Test = Train((batcheSize*(3))+1: batcheSize*4, :);
Train((batcheSize*(3))+1: batcheSize*4, :) = [];

trainImagesCount = size(Train);
trainImagesCount = trainImagesCount(1);
testImagesCount = size(Test);
testImagesCount = testImagesCount(1);


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
    Result(i, 1) = Test(i, 2); % Test Image
    Result(i, 2) = Train(OriginalTrainingOrder(i, 1), 2); % Closet Train Image
    Result(i, 3) = Test(i, 3); % Test Image Name
    Result(i, 4) = Train(OriginalTrainingOrder(i, 1), 3); % Closest Train Image Name
    if strcmp(Result(i, 1), Result(i, 2)) == 1
       correctlyPredicted = correctlyPredicted + 1; 
    end
end

accuracy = (correctlyPredicted * 100) / testImagesCount;

fprintf('\n Accuracy = %.2f %%\n', accuracy);





% %  Calculating Confusion Matrix
[resultCount, columnCount] = size(Result);
ConfusionMatrix = {0,0 ; 0,0};

row=0;
col=0;
for i = 1:resultCount
    if strcmp(Result{i,1}, 'RO-GE')
        row = 1;
    elseif strcmp(Result{i,1}, 'RO-GG')
        row = 2;
    end
    if strcmp(Result{i,2}, 'RO-GE')
        col = 1;
    elseif strcmp(Result{i,2}, 'RO-GG')
        col = 2;
    end
   
    ConfusionMatrix{row, col} = ConfusionMatrix{row, col} + 1;
end
    ConfusionMatrix


