function new_pic = move_obj(img, bckgrnd, direction)
%Takes an image and a background image, and a direction as
%a vector (horizontal shift, vertical shift). Returns a new
%image shifted accordingly and with a background added.

shifted = imtranslate(img, direction, 'FillValues', 127);
grnd = imresize(bckgrnd, [1024, 1024]);
mask = shifted ~=127;
inv_mask = shifted ==127;
mask = cast(mask, class(shifted));
inv_mask = cast(inv_mask, class(shifted));
cut_grnd = grnd.*inv_mask;
new_pic = cut_grnd + shifted.*mask;