% This example demonstrates how HDR-VDP can be used to detect impairments
% in HDR images. The results are shown separately for side-by-side and
% flicker detection tasks.
%
% Note that the predicted visibility of introduced distortions may not much 
% the visibility of those seen on the screen. The HDR images are scaled in
% absolute photometric units and parts of the image are much darker than
% shown in tone-mapped images, making distortions less visible.

if ~exist( 'hdrvdp3', 'file' )
    addpath( fullfile( pwd, '..') );
end


I_ref = hdrread( 'nancy_church.hdr' );

% Make the image smaller so that we can fit more on the screen
I_ref = max( imresize( I_ref, 0.5, 'lanczos2' ), 0.0001 );

% Find the angular resolution in pixels per visual degree:
% 30" 4K monitor seen from 0.5 meters
ppd = hdrvdp_pix_per_deg( 30, [3840 2160], 0.5 );

% Noise

% Create test image with added noise
noise = randn(size(I_ref,1),size(I_ref,2)) .* get_luminance( I_ref ) * 0.2;
I_test_noise = max( I_ref + repmat( noise, [1 1 3] ), 0.0001 );

res_noise_sbs = hdrvdp3( 'side-by-side', I_test_noise, I_ref, 'rgb-native', ppd );
res_noise_flicker = hdrvdp3( 'flicker', I_test_noise, I_ref, 'rgb-native', ppd );

% Blur

% Create test image that is blurry
I_test_blur = imgaussfilt( I_ref, 2 );

res_blur_sbs = hdrvdp3( 'side-by-side', I_test_blur, I_ref, 'rgb-native', ppd, {} );
res_blur_flicker = hdrvdp3( 'flicker', I_test_blur, I_ref, 'rgb-native', ppd, {} );

%

% context image to show in the visualization
I_context = get_luminance( I_ref );

% Visualize images assuming 200 cd/m^2 display
% This size is not going to be correct because we are using subplot
gamma = 2.2;
L_peak = 200; 

clf
subplot( 2, 3, 1 );
imshow( (I_test_noise/L_peak).^(1/gamma) );
title( 'Noisy image' );

subplot( 2, 3, 2 );
imshow( hdrvdp_visualize( res_noise_sbs.P_map, I_context ) );
title( 'Noise, task: side-by-side' );

subplot( 2, 3, 3 );
imshow( hdrvdp_visualize( res_noise_flicker.P_map, I_context ) );
title( 'Noise, task: flicker' );

subplot( 2, 3, 4 );
imshow( (I_test_blur/L_peak).^(1/gamma) );
title( 'Blurry image' );

subplot( 2, 3, 5 );
imshow( hdrvdp_visualize( res_blur_sbs.P_map, I_context ) );
title( 'Blur, task: side-by-side' );

subplot( 2, 3, 6 );
imshow( hdrvdp_visualize( res_blur_flicker.P_map, I_context ) );
title( 'Blur, task: flicker' );

