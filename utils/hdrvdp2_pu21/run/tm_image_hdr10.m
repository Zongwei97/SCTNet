function img_l_TM = tm_image_hdr10( img_l, content_max_L, display_max_L )
% Tone map an image using a plain HDR10 mapping (clamp to the 95th percentile)
%
% img_tm_l = tm_image_hdr10( img_l, content_max_L, display_max_L )
%
% img_l - image in linear optical space and relative units
% content_max_L - the peak luminance of the content
% display_max_L - the peak luminance of the display
%
% Naming convention
% *_L - linear optical absolute (in nits)
% *_l - linear optical relative (max is 1)
% *_E - electrical (in PQ space) absolute
% *_e - electrical (in PQ space) relative (max is 1)
%
% *_TM - image after tone mapping

if ~exist( 'do_plot', 'var' )
    do_plot = false;
end

maxRGB_l = max(img_l,[],3);

anchor_l = max( prctile( maxRGB_l(:), 95 ), display_max_L/content_max_L );

img_l_TM = min( img_l / anchor_l, 1 );

end
