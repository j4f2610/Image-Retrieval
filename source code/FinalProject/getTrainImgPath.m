function [ train_image_paths ] = getTrainImgPath(data_path)
    files = dir(fullfile(data_path,'*.jpg'));
    num_files = numel(files);
    for i = 1 : num_files
        image_file_path = fullfile(data_path, files(i).name);
        train_image_paths{i} = image_file_path;
    end
end

