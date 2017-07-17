function query_vector = createQueryVector(path_of_query_image, db_size)

    query_image = imread(path_of_query_image);
    
    [~, feats] = vl_dsift(single(rgb2gray(query_image)),'fast', 'step', 5);

    load('visualVocabulary.mat');
    vocab_inv = vocab';

    vocab_size = size(vocab, 2);
    query_vector = zeros([1 vocab_size]);

    all_nearest = knnsearch(single(vocab_inv), single(feats'));
    for n=1:size(all_nearest, 1)
        nearest_vocab=all_nearest(n);
        query_vector(nearest_vocab) = query_vector(nearest_vocab)+1;
    end
    
    number_of_words_in_each_doc = sum(query_vector,2);
    total_words = number_of_words_in_each_doc(1,1);
    load('vocaFrequen.mat');
    
     for j = 1: size(query_vector, 2)
        %update tf-idf weighting
        word_frequency = vocab_frequencies_in_DB(1,j);
        query_vector(1, j) = query_vector(1, j)/total_words * (1 + log(db_size/word_frequency));
    end

end
