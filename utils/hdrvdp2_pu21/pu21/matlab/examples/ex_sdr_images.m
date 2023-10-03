% This simple example shows how to call PU21 metrics on SDR images
% assuming a certain display model.

if ~exist( 'pu21_encoder', 'class' )
    addpath( fullfile( pwd, '..') );
end

ref_dir = '/media/alidouiyek/679CB9BC7673EACA/projets/AA/HDR-Transformer-Pytorch-Remote/results/ref_imvia';
test_dir = '/media/alidouiyek/679CB9BC7673EACA/projets/AA/HDR-Transformer-Pytorch-Remote/results/sen_imvia';

ref_files = dir(fullfile(ref_dir,'*.png'));
test_files = dir(fullfile(test_dir,'*.png'));

mean_PSNR = [];
mean_SSIM = [];

for k = 1:length(ref_files)

    % Create test and reference images in the display-encoded colour space
    baseFileName = ref_files(k).name;
    fullFileName = fullfile(ref_dir, baseFileName);
    I_ref = imread(fullFileName);
    
    I_ref = imresize(I_ref,[1000 1500]);
    
    baseFileName2 = test_files(k).name;
    fullFileName2 = fullfile(test_dir, baseFileName2);
    I_test = imread(fullFileName2);

    % The parameters of the display model
    Y_peak = 100; % Display peak luminance in cd/m^2
    contrast = 1000; % 1000:1 contrast
    E_ambient = 10; % Ambient light in lux

    % Create a display model
    pu_dm = pu21_display_model_gog( Y_peak, contrast, [], E_ambient );

    PSNR = pu21_metric( I_test, I_ref, 'PSNR', pu_dm );
    SSIM = pu21_metric( I_test, I_ref, 'SSIM', pu_dm );
    
    mean_psnr(k) =  PSNR;
    mean_ssim(k) = SSIM;
    
    


    fprintf( 1, 'Image with noise: PU21-PSNR = %g dB, PU21-SSIM = %g\n', PSNR, SSIM );
end
mean_psnr = mean(mean_psnr) ;
mean_ssim = mean(mean_ssim);
disp(mean_psnr);
disp(mean_ssim);


