% This example demonstrates how HDR-VDP could be used to estimate loss of
% display quality due to resolution. 
%
% Reference image has the resolution of 240 pixels per degree. The lower
% resolution of the test image is simulated by upsampling with a box filter
% from a lower resolution image. 
%
% Note that this mode of using HDR-VDP has not been fully validated.

if ~exist( 'hdrvdp3', 'file' )
    addpath( fullfile( pwd, '..') );
end

% The input SDR images must have its peak value at 1.
% Note that this is a 16-bit image. Divide by 255 for 8-bit images.
I = double(imread( 'wavy_facade.png' )) / (2^16-1);

% Display parameters
Y_peak = 200;     % Peak luminance in cd/m^2 (the same as nit)
contrast = 1000;  % Display contrast 1000:1
gamma = 2.2;      % Standard gamma-encoding
E_ambient = 100;  % Ambient light = 100 lux

L_ref = hdrvdp_gog_display_model( I, Y_peak, contrast, gamma, E_ambient );

% The maximum resolution considered. 
ppd_max = 240;

% Downsampling factors
ds = 2.^(1:5);

% Pixels per visual degree
PPDs = ppd_max ./ ds;

Qs = zeros(length(PPDs),1);
for kk=1:length(PPDs)
    
    fprintf( 1, 'Processing PPD=%g ...\n', PPDs(kk) );
    
    % Downsample first using a good quality filter
    I_d = imresize( I, 1/ds(kk), 'lanczos2' );
    
    % Then upsample, simulating square pixels
    I_t = clamp( imresize( I_d, [size(I,1) size(I,2)], 'box' ), 0, 1 );

    L_test = hdrvdp_gog_display_model( I_t, Y_peak, contrast, gamma, E_ambient );
    
    res = hdrvdp3( 'quality', L_test, L_ref, 'rgb-native', ppd_max, {} );
    
    Qs(kk) = res.Q;
end

clf
plot( PPDs, Qs, '-o' );
xlabel( 'PPD' );
ylabel( 'Quality' );

