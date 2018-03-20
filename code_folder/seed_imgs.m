function s = seed_imgs(incrmnt)
meta = struct;
%Takes a background image generatedand generates sets of images with 
%a moving target
% @param incrmnt is how many pixels the target moves between 'frames'
selObj = nan;
%Selects index of target images 
for i = 1:10
    obj = i*100-99:i*100;
    selObj = [selObj,randsample(obj,10,false)];
end
selObj(1)=[];
images = zeros(1024,1024,100, 'uint8');
bg = zeros(1024,1024,100, 'uint8');
%reads in target images and background images
for i = 0:99
    cd ('/Users/kohitij/Dropbox (MIT)/jocasta_shared_folder/img_no_bg')
    images(:,:,i+1) = imread(['im', num2str((selObj(i+1)-1)),'.png']);
    for k = 1:18
    	meta(18*i+k).seed_number = selObj(i+1)-1;
    end
    cd ('/Users/kohitij/Dropbox (MIT)/jocasta_shared_folder/bg')
    bg(:,:,i+1) = imread(['im', num2str((selObj(i+1)-1)),'.png']); 
    for k = 1:18
        meta(18*i+k).bg_number = selObj(i+1)-1;
    end
end


cd ('/Users/kohitij/Dropbox (MIT)/jocasta_shared_folder/small_imgs')
cntr = 0;
disp(cntr);
%generates set of 18 'moving' images w/target based on random orientation
orientations = {'north', 'south', 'west', 'east', 'northwest', 'northeast', 'southwest', 'southeast'}; 
for i = 0:99
    rng('shuffle');
    selectOrientation = randsample(1:8, 1,false);
    currentOrientation = orientations{selectOrientation};
    for k = 1:18
       switch(currentOrientation)
     
           case 'north'
             filename = sprintf('im%d.png', cntr); 
             imwrite(move_obj(images(:,:,i+1), bg(:,:,i+1), [0, -incrmnt * k]), filename);
             cntr = cntr +1;
             meta(cntr).direction = 'north';
             
             
           case 'south'
             filename = sprintf('im%d.png', cntr); 
             imwrite(move_obj(images(:,:,i+1), bg(:,:,i+1), [0, incrmnt * k]), filename);
             cntr = cntr+1;
             meta(cntr).direction = 'south';
             
           case 'west'
             filename = sprintf('im%d.png', cntr); 
             imwrite(move_obj(images(:,:,i+1), bg(:,:,i+1), [-incrmnt * k, 0]), filename);
             cntr = cntr+1;
             meta(cntr).direction = 'west';
             
           case 'east'
             filename = sprintf('im%d.png', cntr); 
             imwrite(move_obj(images(:,:,i+1), bg(:,:,i+1), [incrmnt * k, 0]), filename);
             cntr = cntr+1;
             meta(cntr).direction = 'east';
             
           case 'northwest'
             filename = sprintf('im%d.png', cntr); 
             imwrite(move_obj(images(:,:,i+1), bg(:,:,i+1), [-incrmnt * k * sqrt(2), -incrmnt * k * sqrt(2)]), filename);
             cntr = cntr+1;
             meta(cntr).direction = 'northwest';
             
           case 'northeast'
             filename = sprintf('im%d.png', cntr); 
             imwrite(move_obj(images(:,:,i+1), bg(:,:,i+1), [incrmnt * k * sqrt(2), -incrmnt * k * sqrt(2)]), filename);
             cntr = cntr+1;
             meta(cntr).direction = 'northeast';
             
           case 'southwest'
             filename = sprintf('im%d.png', cntr); 
             imwrite(move_obj(images(:,:,i+1), bg(:,:,i+1), [-incrmnt * k * sqrt(2), incrmnt * k * sqrt(2)]), filename);
             cntr = cntr+1;
             meta(cntr).direction = 'southwest';
             
           case 'southeast'
             filename = sprintf('im%d.png', cntr); 
             imwrite(move_obj(images(:,:,i+1), bg(:,:,i+1), [incrmnt * k * sqrt(2), incrmnt * k * sqrt(2)]), filename);
             cntr = cntr+1;
             meta(cntr).direction = 'southeast';
             
       end
    end
end
save('-v7.3','meta.mat','meta');