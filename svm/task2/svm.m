clc;
addr = './';
fname = {'Adam_Levine.txt.rt', 'Taylor_Swift.txt.rt'};
[training_set, training_labels, test_set, test_labels] = dataprocess(addr, fname);

svm_model = svmtrain(training_labels(1:68, :), double(training_set), '-t 0');
accuracy = svmpredict(test_labels(1:17, :), double(test_set), svm_model);
