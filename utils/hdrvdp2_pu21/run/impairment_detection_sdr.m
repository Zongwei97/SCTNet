% This example demonstrates how HDR-VDP can be used to detect impairments
% in SDR images. The results are shown separately for side-by-side and
% flicker detection tasks. The example shows how to use 
% hdrvdp_gog_display_model() to account for display brightness and
% contrast.
%
% Note that the predicted visibility of introduced distortions may not
% match the visibility of those seen on the screen. To match the visibility, 
% you may need to adjust the parameters, such as the peak luminance of the
% display, viewing distance, screen resolution, and others. 

if ~exist( 'hdrvdp3', 'file' )
    addpath( fullfile( pwd, '..') );
end

% Display parameters
Y_peak = 200;     % Peak luminance in cd/m^2 (the same as nit)
contrast = 1000;  % Display contrast 1000:1
gamma = 2.2;      % Standard gamma-encoding
E_ambient = 100;  % Ambient light = 100 lux


% The input SDR images must have its peak value at 1.
% Note that this is a 16-bit image. Divide by 255 for 8-bit images.
I_ref = double(imread( 'wavy_facade.png' )) / (2^16-1);

% Find the angular resolution in pixels per visual degree:
% 30" 4K monitor seen from 0.5 meters
ppd = hdrvdp_pix_per_deg( 30, [3840 2160], 0.5 );

% Noise

% Create test image with added noise
noise = randn(size(I_ref,1),size(I_ref,2)) * 0.02;
I_test_noise = clamp( I_ref + repmat( noise, [1 1 3] ), 0, 1 );

% Converting gamma-encoded images to absolute linear values (using a GOG
% display model).
% Note that we use I_ to denote gamma-encoded images and L_ to denote
% linear images.
L_ref = hdrvdp_gog_display_model( I_ref, Y_peak, contrast, gamma, E_ambient );
L_test_noise = hdrvdp_gog_display_model( I_test_noise, Y_peak, contrast, gamma, E_ambient );

% Note that the color encoding is set to 'rgb-native' since SDR images have
% been converted to absolute linear RGB color space. 
res_noise_sbs = hdrvdp3( 'side-by-side', L_test_noise, L_ref, 'rgb-native', ppd );
res_noise_flicker = hdrvdp3( 'flicker', L_test_noise, L_ref, 'rgb-native', ppd );

% Blur

% Create test image that is blurry
I_test_blur = imgaussfilt( I_ref, 1.5 );


L_test_blur = hdrvdp_gog_display_model( I_test_blur, Y_peak, contrast, gamma, E_ambient );

res_blur_sbs = hdrvdp3( 'side-by-side', L_test_blur, L_ref, 'rgb-native', ppd, {} );
res_blur_flicker = hdrvdp3( 'flicker', L_test_blur, L_ref, 'rgb-native', ppd, {} );

% Below is an example of older invocation with a fixed display moodel
%res_blur_sbs = hdrvdp3( 'side-by-side', I_test_blur, I_ref, 'sRGB-display', ppd, {} );
%res_blur_flicker = hdrvdp3( 'flicker', I_test_blur, I_ref, 'sRGB-display', ppd, {} );


% Context image to show in the visualization. The context image should be
% in the linear space (gamma-decoded).
I_context = L_ref;

% Visualize images
% This size is not going to be correct because we are using subplot

clf
subplot( 2, 3, 1 );
imshow( I_test_noise );
title( 'Noisy image' );

subplot( 2, 3, 2 );
imshow( hdrvdp_visualize( res_noise_sbs.P_map, I_context ) );
title( 'Noise, task: side-by-side' );

subplot( 2, 3, 3 );
imshow( hdrvdp_visualize( res_noise_flicker.P_map, I_context ) );
title( 'Noise, task: flicker' );


subplot( 2, 3, 4 );
imshow( I_test_blur );
title( 'Blurry image' );

subplot( 2, 3, 5 );
imshow( hdrvdp_visualize( res_blur_sbs.P_map, I_context ) );
title( 'Blur, task: side-by-side' );

subplot( 2, 3, 6 );
imshow( hdrvdp_visualize( res_blur_flicker.P_map, I_context ) );
title( 'Blur, task: flicker' );

