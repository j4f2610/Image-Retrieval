function ranked_list =  getCosineValue(imgListPath, query_vector, db_size)

    load('imgvectors.mat');
    ranked_list = cell([2 db_size]);
    nRow = size(imgvectors,1);

    for i = 1:nRow
        u = query_vector;
        v = imgvectors(i,:);
        a=imgListPath{i};
        ranked_list{1, i} = a;
        ranked_list{2, i} = dot(u,v)/(norm(u,2)*norm(v,2));
    end
end