function [image_feats, vocab_frequencies_in_DB] = createVisualWord(image_paths)

load('visualVocabulary.mat');
vocab_size = size(vocab, 2);
db_size = size(image_paths, 1);

image_feats = zeros([db_size vocab_size]);
images=cellfun(@imread, image_paths, 'UniformOutput', false);
vocab_inv = vocab';

parfor i=1:(size(images,1))
    [~, feats] = vl_dsift(single(rgb2gray(images{i})), 'fast', 'step', 5);
    D_matrix = zeros([1 vocab_size]);
    
    all_nearest = knnsearch(single(vocab_inv), single(feats'));
    for n=1:size(all_nearest, 1)
        nearest_vocab=all_nearest(n);
        D_matrix(nearest_vocab) = D_matrix(nearest_vocab)+1;
    end
    %out = 1/norm(D_matrix)*D_matrix;
    %image_feats(i, :) = out;
    image_feats(i, :) = D_matrix;
end

% how many documents does a term occurs in
vocab_frequencies_in_DB = zeros([1 vocab_size]);
for i=1:size(image_feats, 1)
    for j = 1: size(image_feats, 2)
        if(image_feats(i,j) > 0)
            vocab_frequencies_in_DB(1, j) = vocab_frequencies_in_DB(1, j) + 1;
        end
    end
end

number_of_words_in_each_doc = sum(image_feats,2);
%vocab_frequencies_in_DB = sum(image_feats);

for i=1:size(image_feats, 1)
    for j = 1: size(image_feats, 2)
    %update tf-idf weighting
    total_words = number_of_words_in_each_doc(i,1);
    word_frequency = vocab_frequencies_in_DB(1,j);
    image_feats(i, j) = image_feats(i, j)/total_words * (1 + log(db_size/word_frequency));
    end
end


