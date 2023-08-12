#-*- coding:utf-8 -*-

import os.path as osp
import argparse

#from dataset.dataset_iccv23 import ICCV23_Test_Dataset
from dataset.dataset_sig17 import SIG17_Test_Dataset as ICCV23_Test_Dataset

from models.SCTNet import SCTNet

from train_sct import test_single_img
from utils.utils import *

parser = argparse.ArgumentParser(description="Test Setting")
parser.add_argument("--dataset_dir", type=str, default='./our_data',
                        help='dataset directory')
parser.add_argument('--no_cuda', action='store_true', default=False,
                        help='disables CUDA training')
parser.add_argument('--test_batch_size', type=int, default=1, metavar='N',
                        help='testing batch size (default: 1)')
parser.add_argument('--num_workers', type=int, default=1, metavar='N',
                        help='number of workers to fetch data (default: 1)')
parser.add_argument('--patch_size', type=int, default=256)
parser.add_argument('--pretrained_model', type=str, default='./ckpt_sctnet/best_checkpoint.pth')
parser.add_argument('--test_best', action='store_true', default=False)
parser.add_argument('--save_results', action='store_true', default=True)
parser.add_argument('--save_dir', type=str, default="./results_new/")
parser.add_argument('--model_arch', type=int, default=0)

def main():
    # Settings
    args = parser.parse_args()


    # pretrained_model
    print(">>>>>>>>> Start Testing >>>>>>>>>")
    print("Load weights from: ", args.pretrained_model)
    print(args.patch_size)

    # cuda and devices
    use_cuda = not args.no_cuda and torch.cuda.is_available()
    device = torch.device('cuda:0' if use_cuda else 'cpu')
    print(device)

    upscale = 4
    window_size = 8
    height = (256 // upscale // window_size + 1) * window_size
    width = (256 // upscale // window_size + 1) * window_size

    # model architecture
    model_dict = {
        0: SCTNet(img_size=(height, width), in_chans=18,
                            window_size=window_size, img_range=1., depths=[6, 6, 6, 6],
                            embed_dim=60, num_heads=[6, 6, 6, 6], mlp_ratio=2, upsampler='pixelshuffledirect'),
    }
    print(f"Selected model: {args.model_arch}")
    model = model_dict[args.model_arch].to(device)
    model = nn.DataParallel(model, device_ids = [0])
    model.load_state_dict(torch.load(args.pretrained_model)['state_dict'])
    model.eval()

    datasets = ICCV23_Test_Dataset(args.dataset_dir, args.patch_size)
    psnr_l = AverageMeter()
    ssim_l = AverageMeter()
    psnr_mu = AverageMeter()
    ssim_mu = AverageMeter()
    for idx, img_dataset in enumerate(datasets):


        pred_img, label = test_single_img(model, img_dataset, device)

        pred_hdr = pred_img.copy()
        pred_hdr = pred_hdr.transpose(1, 2, 0)[..., ::-1]

        # psnr-l and psnr-\mu

        scene_psnr_l = peak_signal_noise_ratio(label, pred_img, data_range=1.0)
        label_mu = range_compressor(label)
        pred_img_mu = range_compressor(pred_img)
        scene_psnr_mu = peak_signal_noise_ratio(label_mu, pred_img_mu, data_range=1.0)


        # ssim-l
        pred_img = np.clip(pred_img * 255.0, 0., 255.).transpose(1, 2, 0)
        label = np.clip(label * 255.0, 0., 255.).transpose(1, 2, 0)
        scene_ssim_l = calculate_ssim(pred_img, label)
        # ssim-\mu
        pred_img_mu = np.clip(pred_img_mu * 255.0, 0., 255.).transpose(1, 2, 0)
        label_mu = np.clip(label_mu * 255.0, 0., 255.).transpose(1, 2, 0)
        scene_ssim_mu = calculate_ssim(pred_img_mu, label_mu)

        psnr_l.update(scene_psnr_l)
        ssim_l.update(scene_ssim_l)
        psnr_mu.update(scene_psnr_mu)
        ssim_mu.update(scene_ssim_mu)


        print(f' {idx} | 'f'PSNR_mu: {scene_psnr_mu:.4f}  PSNR_l: {scene_psnr_l:.4f} | SSIM_mu: {scene_ssim_mu:.4f}  SSIM_l: {scene_ssim_l:.4f}')

        # save results
        if args.save_results:
            if not osp.exists(args.save_dir):
                os.makedirs(args.save_dir)
            cv2.imwrite(os.path.join(args.save_dir, '00{}_pred.png'.format(idx)), pred_img_mu)
            cv2.imwrite(os.path.join(args.save_dir, '00{}_pred.hdr'.format(idx)), pred_hdr[:, :, ::-1])
            cv2.imwrite(os.path.join(args.save_dir, '00{}_gt.png'.format(idx)), label_mu)

    print("Average PSNR_mu: {:.4f}  PSNR_l: {:.4f}".format(psnr_mu.avg, psnr_l.avg))
    print("Average SSIM_mu: {:.4f}  SSIM_l: {:.4f}".format(ssim_mu.avg, ssim_l.avg))
    print(">>>>>>>>> Finish Testing >>>>>>>>>")


if __name__ == '__main__':
    main()
