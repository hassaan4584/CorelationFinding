function [ output_arg1, CorMat ] = Corr_function( TrainData, TestData )
%CORR_FUNCTION Summary of this function goes here
%   Detailed explanation goes here
    

    trainImagesCount = size(TrainData);
    trainImagesCount = trainImagesCount(1);
    testImagesCount = size(TestData);
    testImagesCount = testImagesCount(1);
    
%     trainImagesCount = 3;
%     testImagesCount = 2;
    fprintf('\n Calculating Corelation Matrix\n')
    TestCor = eye(1, 1);
    for i = 1:testImagesCount
       for j = 1:trainImagesCount
           TestCor(i, j) = corr2(TestData{i, 1}, TrainData{j, 1});
        
       end    
    end
    
    Result = cell(testImagesCount, 4);
%     Result(1, 1) = {'Test Class'};
%     Result(1, 2) = {'Predicted Class'};
%     Result(1, 3) = {'Test Class Name'};
%     Result(1, 4) = {'Predicted Class Name'};

    [A, OriginalTrainingOrder] = sort(TestCor, 2, 'descend');
    correctlyPredicted = 0;
    for i = 1:testImagesCount
        Result(i, 1) = TestData(i, 2); % Test Image
        Result(i, 2) = TrainData(OriginalTrainingOrder(i, 1), 2); % Closet Train Image
        Result(i, 3) = TestData(i, 3); % Test Image Name
        Result(i, 4) = TrainData(OriginalTrainingOrder(i, 1), 3); % Closest Train Image Name
        if strcmp(Result(i, 1), Result(i, 2)) == 1
           correctlyPredicted = correctlyPredicted + 1; 
        end
    end

    accuracy = (correctlyPredicted * 100) / testImagesCount;

    fprintf('\n Accuracy = %.2f %%\n', accuracy);


    % %  Calculating Confusion Matrix
    [resultCount, ~] = size(Result);
    ConfusionMatrix = {0,0 ; 0,0};

    row=0;
    col=0;
    for i = 2:resultCount
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

    output_arg1 = Result ;
    CorMat = TestCor;


end

