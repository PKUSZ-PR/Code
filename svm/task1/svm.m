clc;

% enable parallel computing
if isempty(gcp('nocreate')) 
    cluster = parcluster('local');
    cluster.NumWorkers = 4;
    parpool(cluster, cluster.NumWorkers);
end

% read the data, dividing it into training set and test set
[set, labels] = load_images('./IMDB_WIKI/imdb_data/', 1000);

% extract the feature using cnn
alex_neural_network = alexnet;
layer = 'fc7';
set = activations(alex_neural_network, set, layer);

% use PCA to reduct dimension
eigen_vector = pca(set);
training_set = set * eigen_vector(:, 1:700);

% classfy the test data(male and female) using libsvm and 10-fold validation
svm_model = svmtrain(labels, double(training_set), '-v 10');
