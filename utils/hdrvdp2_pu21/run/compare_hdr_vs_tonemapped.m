% Detect contrast loss, amplification and reversal for a pair of HDR and
% tone-mapped images. 
%
% This example demonstrates 'civdm' mode - Contrast Invariant Visibility
% Difference Metric, which is a variation of the Dynamic Range Independent
% Metric from the paper:
%
% T. O. Aydin, R. Mantiuk, K. Myszkowski, and H.-P. Seidel, 
% "Dynamic range independent image quality assessment", 
% ACM Trans. Graph. (Proc. SIGGRAPH), vol. 27, no. 3, p. 69, 2008.

if ~exist( 'hdrvdp3', 'file' )
    addpath( fullfile( pwd, '..') );
end

I_hdr = hdrread( 'nancy_church.hdr' );

I_tmo = cell(3,1);
I_tmo{1} = double(imread( 'nancy_church_mai11.png' ))/255;
I_tmo{2} = double(imread( 'nancy_church_saturated.png' ))/255;
I_tmo{3} = double(imread( 'nancy_church_mantiuk06.png' ))/255;


% Run the Contrast Invariant Visibility Difference Metric on each
% tone-mapped image
res = cell(length(I_tmo),1);
vis = cell(length(I_tmo),1);
for kk=1:length(I_tmo)
    fprintf( 1, '.' );
    
    % Find the angular resolution in pixels per visual degree:
    % 30" 4K monitor seen from 0.5 meters
    ppd = hdrvdp_pix_per_deg( 30, [3840 2160], 0.5 ); 
    
    % Convert from gamma corrected pixel values stored in SDR images 
    % to linear colorimetric values shown on a display with the peak
    % luminance of 200 cd/m^2
    Y_tone_mapped = hdrvdp_gog_display_model( I_tmo{kk}, 200 );
    
    tic;
    res{kk} = hdrvdp3( 'civdm', Y_tone_mapped, I_hdr, 'rgb-native', ppd );
    toc
   
    vis{kk} = hdrvdp_visualize( 'civdm', res{kk}.civdm, I_hdr );
end
fprintf( 1, '\n' );

clf
imshow( cat( 1, cat( 2, I_tmo{1}, I_tmo{2}, I_tmo{3} ) , cat( 2, vis{1}, vis{2}, vis{3} ) ) )
title( 'Predictions for an image tone-mapped with three different operators' );




