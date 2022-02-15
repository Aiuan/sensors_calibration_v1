function image_list = getImageListIncludeNotFound(image_folder)
    fileList=dir(image_folder);
    prefix = 'match';
    postfix = '.';
    image_list = {};
    for i=1:length(fileList) 
        if ~fileList(i).isdir
            image_file_name=fileList(i).name;
            prefix_index = strfind(image_file_name, prefix);
            prefix_len = size(prefix,2);
            postfix_index = strfind(image_file_name, postfix);
            postfix_len = size(postfix,2);
            
            notFoundIndex = strfind(image_file_name, "_notFound");
            if isempty(notFoundIndex)
                image_id = image_file_name(prefix_index+prefix_len : postfix_index-1);
            else
                image_id = image_file_name(prefix_index+prefix_len : notFoundIndex-1);
            end
                          
            image_id = str2num(image_id);  
            image_list(image_id).name = image_file_name;
            image_list(image_id).path = strcat(image_folder, image_file_name);
        end
    end

end
