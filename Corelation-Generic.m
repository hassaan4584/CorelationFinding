% 
% fprintf('\n Reading Training Data\n')
% trainPath='/Volumes/Parhai/Parhai/LUMS/Semester 4 Spring18/Thesis 2/Datasets/GG+W/RO-Scanned Forms/Train';
% trainFolderContents = dir(trainPath);
% count = size(trainFolderContents);
% trainClasses = cell(5, 1);
% 
% % Reading class names
% for i = 4:count(1)
%    if trainFolderContents(i, 1).isdir == 1
%        trainClasses{i, 1} = trainFolderContents(i, 1).name;
%    end
% end
% 
% %  Reading Train Data
% Train = cell(50, 2);
% trainImagesCount=0;
% 
% for i = 4:count(1)
%     if trainFolderContents(i, 1).isdir == 1 
%         trainClasses{i, 1} = trainFolderContents(i, 1).name;
%         classPath = strcat(trainPath, '/', trainClasses{i, 1});
%         classContents = dir(classPath);
%         imageCount = size(classContents);
%         for j = 1:imageCount(1)
%             if classContents(j, 1).isdir == 0  && (strcmp(classContents(j, 1).name, '.DS_Store')== 0)
%                 trainImageName = classContents(j, 1).name;
%                 imagePath = strcat(classPath, '/', trainImageName);
%                 try
%                     temp = imread(char(imagePath));
%                     trainImagesCount = trainImagesCount + 1;
%                     Train{trainImagesCount, 1} = rgb2gray(temp);
%                     Train{trainImagesCount, 2} = trainClasses{i, 1};
%                 catch
%                     fprintf('j=%i, imagePath=%s , ', j, imagePath)
%                 end
%            end
%        end
%    end
% end
% 
% 
% 
% fprintf('\n Reading Test Data\n')
% 
% testPath='/Volumes/Parhai/Parhai/LUMS/Semester 4 Spring18/Thesis 2/Datasets/GG+W/RO-Scanned Forms/Test';
% testFolderContents = dir(testPath);
% testCount = size(testFolderContents);
% testClasses = cell(5, 1);
% 
% % Reading class names
% for i = 4:testCount(1)
%    if testFolderContents(i, 1).isdir == 1
%        testClasses{i, 1} = testFolderContents(i, 1).name;
%    end
% end
% 
% Test = cell(50, 2);
% testImagesCount=0;
% 
% for i = 4:testCount(1)
%     if testFolderContents(i, 1).isdir == 1 
%         testClasses{i, 1} = testFolderContents(i, 1).name;
%         testClassPath = strcat(testPath, '/', testClasses{i, 1});
%         testClassContents = dir(testClassPath);
%         imageCount = size(testClassContents);
%         for j = 4:imageCount(1)
%             if testClassContents(j, 1).isdir == 0
%                 imageName = testClassContents(j, 1).name;
%                 imagePath = strcat(testClassPath, '/', imageName);
%                 temp = imread(char(imagePath));
%                 testImagesCount = testImagesCount + 1;
%                 Test{testImagesCount, 1} = rgb2gray(temp);
%                 Test{testImagesCount, 2} = testClasses{i, 1};
%            end
%        end
%    end
% end
% 
% 
% fprintf('\n Calculating Corelation Matrix\n')
% TestCor = eye(50, 50);
% for i = 1:testImagesCount
%    for j = 1:trainImagesCount
%        TestCor(i, j) = corr2(Test{i, 1}, Train{j, 1});
%     
%    end    
% end
% 

[A, OriginalTrainingOrder] = sort(TestCor, 2, 'descend');
Result = cell(testImagesCount, 2);
correctlyPredicted = 0;
for i = 1:testImagesCount
    Result(i, 1) = Test(i, 2);
    Result(i, 2) = Train(OriginalTrainingOrder(i, 1), 2);
    if strcmp(Result(i, 1), Result(i, 1)) == 1
       correctlyPredicted = correctlyPredicted + 1; 
    end
end

accuracy = (correctlyPredicted * 100) / testImagesCount;

fprintf('\n Accuracy = %.2f %%\n', accuracy);








