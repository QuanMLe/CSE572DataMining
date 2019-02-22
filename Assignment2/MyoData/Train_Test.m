function [Precision_SVM, Recall_SVM, F_score_SVM, Precision_DT, Recall_DT, F_score_DT,...
    Precision_NN, Recall_NN, F_score_NN] = ...
    Train_Test(Training_Eat_Data,Training_NotEat_Data, Test_Eat_Data, Test_NotEat_Data)

    X_train = [Training_Eat_Data; Training_NotEat_Data];
    y_train = [ones(size(Training_Eat_Data, 1), 1); zeros(size(Training_NotEat_Data, 1), 1)];
    X_test = [Test_Eat_Data; Test_NotEat_Data];
    y_test = [ones(size(Test_Eat_Data, 1), 1); zeros(size(Test_NotEat_Data, 1), 1)];

    X = [X_train; X_test];

    [coeff,~,~] = pca(X, 'Economy', false);
    X_PCA = X * coeff(: , 1 : 10);

    X_train_PCA = X_PCA (1 : size(X_train, 1), :);
    X_test_PCA = X_PCA (size(X_train, 1) + 1 : end, :);

    % ::::....:::: SVM ::::....::::
    SVMModel = fitcsvm(X_train_PCA,y_train,'Standardize',true,'KernelFunction','RBF',...
        'KernelScale','auto');
    label_SVM = predict(SVMModel,X_test_PCA);


    [confMat, ~] = confusionmat(label_SVM, y_test);
    for i =1:size(confMat,1)
        precision(i)=confMat(i,i)/sum(confMat(i,:)); 
    end
    precision(isnan(precision))=[];
    Precision_SVM=sum(precision)/size(confMat,1);

    for i =1:size(confMat,1)
        recall(i)=confMat(i,i)/sum(confMat(:,i));  
    end

    Recall_SVM=sum(recall)/size(confMat,1);
    F_score_SVM=2*Recall_SVM*Precision_SVM/(Precision_SVM+Recall_SVM);


    % ::::....:::: Decision Tree ::::....::::
    tree = fitctree(X_train_PCA,y_train);
    label_DT = predict(tree,X_test_PCA);

    [confMat, ~] = confusionmat(label_DT, y_test);
    for i =1:size(confMat,1)
        precision(i)=confMat(i,i)/sum(confMat(i,:)); 
    end
    precision(isnan(precision))=[];
    Precision_DT=sum(precision)/size(confMat,1);

    for i =1:size(confMat,1)
        recall(i)=confMat(i,i)/sum(confMat(:,i));  
    end

    Recall_DT=sum(recall)/size(confMat,1);
    F_score_DT=2*Recall_DT*Precision_DT/(Precision_DT+Recall_DT);

    % ::::....:::: NeuralNetwork ::::....::::

    net = feedforwardnet(10);
    net = train(net, X_train_PCA', y_train');
    label_NN = sim(net, X_test_PCA');
    label_NN(label_NN>=0.5) = 1;
    label_NN(label_NN<0.5) = 0;
    [confMat, ~] = confusionmat(label_NN, y_test);
    for i =1:size(confMat,1)
        precision(i)=confMat(i,i)/sum(confMat(i,:)); 
    end
    precision(isnan(precision))=[];
    Precision_NN=sum(precision)/size(confMat,1);

    for i =1:size(confMat,1)
        recall(i)=confMat(i,i)/sum(confMat(:,i));  
    end

    Recall_NN=sum(recall)/size(confMat,1);
    F_score_NN=2*Recall_NN*Precision_NN/(Precision_NN+Recall_NN);


end

