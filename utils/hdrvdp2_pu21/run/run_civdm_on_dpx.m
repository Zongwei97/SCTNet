
display_max_L = 500; % in cd/m^2
content_max_L = 2000; % in cd/m^2

% Load HDR image (requires pfstools)
I_HDR = pfs_read_image( '/home/rkm38/tmp/huawei_test_images/HUAWEI_all000005.dpx' );
%I_HDR = pfs_read_image( 'image_name.dpx' );

% Make the 4K image smaller so that it can be processed in reasonable time
I_HDR = imresize( I_HDR, 0.5 );

% Image in relative linear units, clamp to avoid too small values
I_HDR_l = max( 0.005/content_max_L, I_HDR / max(I_HDR(:)) );

% A simple HDR10 tone-mapping
I_TM_l = tm_image_hdr10( I_HDR_l, content_max_L, display_max_L );

% Transform to the absolute linear colorimetric units 
I_HDR_L = I_HDR_l * content_max_L;
I_TM_L = I_TM_l * display_max_L;

% Find the angular resolution in pixels per visual degree:
% 100" 4K TV set seen from 1.5 meters
ppd = hdrvdp_pix_per_deg( 100, [3840 2160], 1.5 );

% Run CIVDM
res = hdrvdp3( 'civdm', I_TM_L, I_HDR_L, 'rgb-bt.2020', ppd );

clf
imshow( hdrvdp_visualize( 'civdm', res.civdm ) );
