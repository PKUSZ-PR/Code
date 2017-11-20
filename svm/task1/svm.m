clc;

% enable parallel computing
if isempty(gcp('nocreate')) == 0  
    cluster = parcluster('local');
    cluster.NumWorkers = 4;
    parpool(cluster, cluster.NumWorkers);
end

% read the data, dividing it into training set and test set
[training_set, training_labels] = load_images('./IMDB_WIKI/train_imdb_data/', 800);
[test_set, test_labels] = load_images('./IMDB_WIKI/test_imdb_data/', 200);

% extract the feature using cnn
alex_neural_network = alexnet;
layer = 'fc7';
training_set = activations(vgg_neural_network, training_set, layer);
test_set = activations(vgg_neural_network, test_set, layer);

% use PCA to reduct dimension
eigen_vector = pca(training_set);
training_set = training_set * eigen_vector(:, 1:4096);
test_set = test_set * eigen_vector(:, 1:4096);

% classfy the test data(male and female) using libsvm
svm_model = svmtrain(training_labels, double(training_set), '-t 0');
accuracy = svmpredict(test_labels, double(test_set), svm_model);
