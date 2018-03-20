function s = obj_bg()
%From a folder of 1000 'background' images, selects 100 at random, and 
%selects distractor objects to paste onto the background that are
%unique from the target image
% @author Jocasta Manasseh-Lewis
% @version 03.20.18
array = 1:1000; %gets vector filled with integers 1-1000 inclusive
%for each 10 copies of target, randomly selects image of distractor
for j = 1:10
    num(j,:) = randsample(find(~ismember(array,j*100-99:j*100)), 10, false);
end
cd('/Users/cass/Dropbox/jocasta_shared_folder/bg')
%reads in background images
for i = 0:999
    bg(:,:,i+1) = imread(['im', num2str(i),'.png']);
end
bg_sample = zeros(1024,1024,100, 'uint8');
%stores image information in meta
i = 1;
for r = 1:10
    for c = 1:10
        meta(i).distractor = ceil(num(r, c)/100);
        meta(i).target = r;
        meta(i).im_number = num(r,c) - 1;
        i = i+1;
    end
end
%selects correct background images
i = 1;
for r = 1:10
    for c = 1:10
        bg_sample(:, :, i) = bg(:, :, num(r,c));
        i = i+1;
    end
end
cd('/Users/cass/Dropbox/jocasta_shared_folder/img_no_bg')
imgs = zeros(1024,1024,1000, 'uint8');
im_sample = zeros(1024,1024,100, 'uint8');
%reads in distractor images
for i = 0:999
    imgs(:,:,i+1) = imread(['im', num2str(i),'.png']);
end
%selects correct distractor images
i = 1;
for r = 1:10
    for c = 1:10
        im_sample(:, :, i) = imgs(:, :, num(r,c));
        i = i+1;
    end
end
new_sample = zeros(1024,1024,100, 'uint8');
%overlays distractor image onto background
for k = 1:100
    new_sample(:, :, k) = move_obj(im_sample(:, :, k), bg_sample(:, :, k), [0,0]);
end
cd('/Users/cass/Desktop/bg_3')
%writes distractor+background image into a set of files
for k = 1:100
    filename = sprintf('im%d.png', k-1);
    imwrite(new_sample(:, :, k), filename);
end
%sets move directions in meta
orientations = {'north', 'south', 'west', 'east', 'northwest', 'northeast', 'southwest', 'southeast'}; 
for i = 0:99
    rng('shuffle');
    selectOrientation = randsample(1:8, 1,false);
    meta(i+1).currentOrientation = orientations{selectOrientation};
end
save -v7.3 metanew meta
end