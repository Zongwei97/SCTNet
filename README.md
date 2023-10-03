# Alignment-free HDR Deghosting with Semantics Consistent Transformer

[Steven Tel](https://scholar.google.com/citations?user=OhVOZ8oAAAAJ&hl=en) *, [Zongwei Wu](https://scholar.google.fr/citations?user=3QSALjX498QC&hl=en) *, [Yulun Zhang](https://scholar.google.fr/citations?user=ORmLjWoAAAAJ&hl=en&oi=ao) $`^\dagger`$, [Barthélémy Heyrman](https://scholar.google.fr/citations?user=2VOpb80AAAAJ&hl=en&oi=ao), [Cédric Demonceaux](https://scholar.google.fr/citations?user=CCvaUR4AAAAJ&hl=en), [Radu Timofte](https://scholar.google.fr/citations?user=u3MwH5kAAAAJ&hl=en), and [Dominique Ginhac](https://scholar.google.fr/citations?user=fkdCT5kAAAAJ&hl=en&oi=ao), "Alignment-free HDR Deghosting with Semantics Consistent Transformer", ICCV, 2023

[[arXiv](https://arxiv.org/pdf/2305.18135.pdf)][[supp](https://github.com/Zongwei97/SCTNet/blob/main/Supp/Supplementary.pdf)]

---

Note that there are some corrections made to the conference proceedings to address issues with the production of our benchmark input. We have now updated Table 3 and Figure 6 to reflect these changes. Please refer to [Manuscript](https://arxiv.org/pdf/2305.18135.pdf), [Supplementary](https://github.com/Zongwei97/SCTNet/blob/main/Supp/Supplementary.pdf) and [Web](https://steven-tel.github.io/sctnet/).

---

> **Abstract:** *High dynamic range (HDR) imaging aims to retrieve information from multiple low-dynamic range inputs to generate realistic output. The essence is to leverage the contextual information, including both dynamic and static semantics, for better image generation. Existing methods often focus on the spatial misalignment across input frames caused by the foreground and/or camera motion. However, there is no research on jointly leveraging the dynamic and static context in a simultaneous manner.  To delve into this problem, we propose a novel alignment-free network with a Semantics Consistent Transformer (SCTNet) with both spatial and channel attention modules in the network. The spatial attention aims to deal with the intra-image correlation to model the dynamic motion, while the channel attention enables the inter-image intertwining to enhance the semantic consistency across frames. Aside from this, we introduce a novel realistic HDR dataset with more variations in foreground objects, environmental factors, and larger motions. Extensive comparisons on both conventional datasets and ours validate the effectiveness of our method, achieving the best trade-off on the performance and the computational cost.*
>
> <img src="https://github.com/Zongwei97/SCTNet/blob/main/Supp/abstract.png"  width="500" />

---

## Our Dataset and Benchmark

Our HDR dataset can be found [here](https://drive.google.com/drive/folders/1CtvUxgFRkS56do_Hea2QC7ztzglGfrlB)

We retrain several SOTA counterparts from the official codes.  The quantitative performances are as follows:

![abstract](https://github.com/Zongwei97/SCTNet/blob/main/Supp/Benchmark.png)

The benchmarking results are available at [Google Drive](https://drive.google.com/file/d/1fCQh26zwwVUdWCC8GsnPdRa9J9MUuqM_/view?usp=sharing).
The HDR-VDP-2 and PU21 metrics can be computed using the provided script:
```
matlab utils/hdrvdp2_pu21/run/test.m
```

## Train and Test

We introduce SCTNet, an end-to-end model for HDR deghosting.

![abstract](https://github.com/Zongwei97/SCTNet/blob/main/Supp/Model.png)

To train our model, please follow the training and evaluation steps:

```
python train_sct.py.py
python test_sct.py.py
```
Make sure that you have changed the path to your dataset/ckpts in both files.

To use our dataset, just set the right data path in the training file.

# Citation

If you find this repo useful, please consider citing:

```
@INPROCEEDINGS{tel2023alignment,
  title={Alignment-free HDR Deghosting with Semantics Consistent Transformer},
  author={Tel, Steven and Wu, Zongwei and Zhang, Yulun and Heyrman, Barth{\'e}l{\'e}my and Demonceaux, C{\'e}dric and Timofte, Radu and Ginhac, Dominique},
  booktitle={ICCV}, 
  year={2023},
}
  
```

# Acknowledgments
This repository is heavily based on [HDR-Transformer](https://github.com/liuzhen03/HDR-Transformer-PyTorch). Thanks to their great work!
