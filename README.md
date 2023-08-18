# SCTNet ICCV'23

This is the official implementation of Alignment-free HDR Deghosting with Semantics Consistent Transformer, accepted in ICCV'23.

Project page [web](https://steven-tel.github.io/sctnet/)

> **Authors:** 
> [Steven Tel](https://imvia.u-bourgogne.fr/equipe/tel-steven) *,
> [Zongwei Wu](https://scholar.google.fr/citations?user=3QSALjX498QC&hl=en) *,
> [Yulun Zhang](https://scholar.google.fr/citations?user=ORmLjWoAAAAJ&hl=en&oi=ao) $`^\dagger`$, 
> [Barthélémy Heyrman](https://scholar.google.fr/citations?user=2VOpb80AAAAJ&hl=en&oi=ao),
> [Cédric Demonceaux](https://scholar.google.fr/citations?user=CCvaUR4AAAAJ&hl=en),
> [Radu Timofte](https://scholar.google.fr/citations?user=u3MwH5kAAAAJ&hl=en),
> and [Dominique Ginhac](https://scholar.google.fr/citations?user=fkdCT5kAAAAJ&hl=en&oi=ao).

## Abstract

High dynamic range (HDR) imaging aims to retrieve information from multiple low-dynamic range inputs to generate realistic output. The essence is to leverage the contextual information, including both dynamic and static semantics, for better image generation. Existing methods often focus on the spatial misalignment across input frames caused by the foreground and/or camera motion. However, there is no research on jointly leveraging the dynamic and static context in a simultaneous manner.  To delve into this problem, we propose a novel alignment-free network with a Semantics Consistent Transformer (SCTNet) with both spatial and channel attention modules in the network. The spatial attention aims to deal with the intra-image correlation to model the dynamic motion, while the channel attention enables the inter-image intertwining to enhance the semantic consistency across frames. Aside from this, we introduce a novel realistic HDR dataset with more variations in foreground objects, environmental factors, and larger motions. Extensive comparisons on both conventional datasets and ours validate the effectiveness of our method, achieving the best trade-off on the performance and the computational cost.

<img src="https://github.com/Zongwei97/SCTNet/blob/main/Imgs/abstract.png"  width="500" />


## Dataset

Our HDR dataset can be found from [here](https://cloud.u-bourgogne.fr/index.php/s/rytg9Zf9qWjk9Mb)

To use our dataset, just set the right data path in the training file.


## Train and Test

Please follow the training and evaluation steps:

```
python train_sct.py.py
python test_sct.py.py
```
Make sure that you have changed the path to your dataset/ckpts in both files.

Our ckpt for our dataset can be found here ([Google Drive](https://drive.google.com/file/d/1k3H9kQ1STanGABiEDAcrAzWdAGuxI0ZG/view?usp=sharing))


## Our results

Our results can be found here ([Google Drive](https://drive.google.com/file/d/17sH3azAp6cmd7hIvI7wL4dXTKPvEYe3R/view?usp=sharing))

![abstract](https://github.com/Zongwei97/SCTNet/blob/main/Imgs/quanti.png)


![abstract](https://github.com/Zongwei97/SCTNet/blob/main/Imgs/results.png)



# Acknowledgments
This repository is heavily based on [HDR-Transformer](https://github.com/liuzhen03/HDR-Transformer-PyTorch). Thanks to their great work!
