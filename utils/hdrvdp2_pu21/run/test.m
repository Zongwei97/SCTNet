if ~exist( 'hdrvdp3', 'file' )
    addpath( fullfile( pwd, '..') );
end

if ~exist( 'pu21_encoder', 'class' )
    addpath( fullfile( pwd, '..') );
end




% Dir containing results from all compared networks and GT
% Please download the 
benchmark_dir = 'images/Benchmark/';

% GT DIRs
ref_dir = strcat(benchmark_dir, 'GT', '/gt_hdr');
ref_dir_png = strcat(benchmark_dir, 'GT', '/gt_png');

% Names of the compared networks in benchmark dir
networks = {'SCTNet', 'AHDRNet', 'DHDRNet', 'HDRTransformer', 'NHDRRNet'};



% Loop over each compared network
for i = 1:length(networks)
    
    disp(networks{i});

    % Result Test DIR
    test_dir = strcat(benchmark_dir, networks{i}, '/pred_hdr');
    test_dir_png = strcat(benchmark_dir, networks{i} , '/pred_png');



    ref_files = dir(fullfile(ref_dir,'*.hdr'));
    test_files = dir(fullfile(test_dir,'*.hdr'));


    ref_files_png = dir(fullfile(ref_dir_png,'*.png'));
    test_files_png = dir(fullfile(test_dir_png,'*.png'));



    ppd = hdrvdp_pix_per_deg(30, [1500 1000], 0.55);
    mean_q = 0;
    mean_psnr = [];
    mean_ssim = [];

    

    for k = 1:length(ref_files)
        
      disp(k);
      baseFileName = ref_files(k).name;
      fullFileName = fullfile(ref_dir, baseFileName);
      I_ref = hdrread(fullFileName);


      baseFileName_png = ref_files_png(k).name;
      fullFileName_png = fullfile(ref_dir_png, baseFileName_png);
      I_ref_png = imread(fullFileName_png);


      % The parameters of the display model
      Y_peak = 55; % Display peak luminance in cd/m^2
      contrast = 1000; % 1000:1 contrast
      E_ambient = 10; % Ambient light in lux

      % Create a display model
      pu_dm = pu21_display_model_gog( Y_peak, contrast, [], E_ambient );

      baseFileName2 = test_files(k).name;
      fullFileName2 = fullfile(test_dir, baseFileName2);
      I_test = hdrread(fullFileName2);

      baseFileName2_png = test_files_png(k).name;
      fullFileName2_png = fullfile(test_dir_png, baseFileName2_png);
      I_test_png = imread(fullFileName2_png);
      
      %disp(fullFileName_png)
      %disp(fullFileName2_png)

      res = hdrvdp(I_test, I_ref, 'sRGB-display', ppd ,{ 'disable_lowvals_warning', 'true' } );



      PSNR = pu21_metric( I_test_png, I_ref_png, 'PSNR', pu_dm );
      SSIM = pu21_metric(  I_test_png, I_ref_png, 'SSIM', pu_dm );

      %disp(PSNR)
      %disp(SSIM)

      mean_psnr(k) =  PSNR;
      mean_ssim(k) = SSIM;



      mean_q = mean_q + res.Q;

    end
    disp('---');
    mean_q = mean_q / length(ref_files);
    mean_psnr = mean(mean_psnr) ;
    mean_ssim = mean(mean_ssim);
    
    disp('HDR-VDP2: ');
    disp(mean_q);
    disp('PU-PSNR: ');
    disp(mean_psnr);
    disp('PU-SSIM: ');
    disp(mean_ssim);
    disp('######');
    

end


