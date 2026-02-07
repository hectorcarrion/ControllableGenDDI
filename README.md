# Controllable Generation of Diverse Dermatological Imagery for Fair and Efficient Malignancy Classification

This repository is the official anonimized implementation of **cgDDI**, a hybrid framework for controllable generation of diverse dermatological imagery to support fair and efficient malignancy classification.

**NOTE:** As the notebooks include visualized results, they may not load directly on GitHub—please open locally (or on Colab) if this happens. The code was originally run on Colab, which comes with the majority of requirements. If the base Colab image does not contain a requirement, the notebook includes a `!pip install` call with any missing packages.

---

## Dataset

Our dataset can be found on the attached anonymous bucket: [https://storage.googleapis.com/review_submission_bucket/ControllabeGenDDI.zip](https://storage.googleapis.com/review_submission_bucket/ControllabeGenDDI.zip)

---

## Running the Code

### Healthy Synthetics

To generate healthy synthetics please run `healthy_gen.ipynb`.

We do not re-host previous artifacts, thus remember to **fetch the original DDI dataset** at [https://ddi-dataset.github.io/](https://ddi-dataset.github.io/) and the **sDDI masks from** [https://github.com/hectorcarrion/FEDD](https://github.com/hectorcarrion/FEDD).

### Lesion Mapping Synthetics

To generate lesion-mapped images please run `lesion_mapping.ipynb`.

### Textual Inversion

To train the Textual Inversion model please run `textual_inversion.ipynb`.
Note that you must provide a CSV of the downloaded DDI data you fetched in the previous step, with disease mapping from the original data (if desired) as included in the notebook.

### LoRA Fine-tuning

To fine-tune with your textual-inversion disease special tokens, please run `train_lora.ipynb`.

### Semantic Synthetics

To sample semantic synthetics, please run `semantic_sampling.ipynb`.

### Classification and Fairness

To run classification experiments please see [https://github.com/aayushmanace/PatchAlign24](https://github.com/aayushmanace/PatchAlign24).
Download cgDDI data and CSV, replace input directories with these directories. Ensure to drop any rows of lesion-mapped imagery which has been generated with prompts inside the test set.

---

## Implementation details

### S1. Joined DDI Disease Category Grouping

We consolidate 78 original DDI disease labels into 65 categories based on histopathological similarity and standard dermatological practice. Representative groupings are shown below:

| Original DDI Labels | Joined DDI Category |
|---|---|
| basal-cell-carcinoma, basal-cell-carcinoma-superficial, basal-cell-carcinoma-nodular | Basal Cell Carcinoma |
| melanoma-in-situ, melanoma-acral-lentiginous, nodular-melanoma, melanoma | Melanoma |
| squamous-cell-carcinoma-in-situ, squamous-cell-carcinoma, squamous-cell-carcinoma-keratoacanthoma | Squamous Cell Carcinoma |
| mycosis-fungoides, subcutaneous-t-cell-lymphoma | Cutaneous T-Cell Lymphoma |
| seborrheic-keratosis-irritated, seborrheic-keratosis | Seborrheic Keratosis |
| melanocytic-nevi, dysplastic-nevus | Nevus |
| verruca-vulgaris, wart | Verruca Vulgaris |
| benign-keratosis, inverted-follicular-keratosis | Benign Keratosis |
| atypical-spindle-cell-nevus-of-reed, pigmented-spindle-cell-nevus-of-reed | Spindle Cell Nevus of Reed |

The remaining categories have a one-to-one mapping between original and joined labels. After grouping, 25 diseases have a single observation, 27 contain 2–10 samples, and 13 have more than 10 observations.

---

### S2. Review Protocol and Discard Criteria

We establish quality control protocols for each generation type. Review was conducted by two researchers with experience in dermatological AI.

#### S2.1 Healthy Synthetics

All 334 candidate healthy synthetics were manually reviewed. Discard criteria:

1. Original lesion remains present
2. Unrealistic skin texture
3. Incorrect skin tone
4. Generative artifacts (unexpected holes, eyes, lighting, etc.)

After review, 309 healthy synthetics were kept (7% discard rate).

#### S2.2 Lesion-Mapped Synthetics

Given 309 healthy images and 334 sDDI masks, 103,206 candidate synthetics are possible. Algorithmic padding constraints (minimum 10 pixels from skin mask edges) discarded 22,779 samples (22%), yielding 80,427 lesion-mapped synthetics.

#### S2.3 Semantic Synthetics

We observed via ablation (see Section S5) that approximately 10 training samples are the minimum for viable generation quality. Synthetics produced with ≤10 training samples exhibit:

1. Unrealistic skin texture
2. Anatomical inconsistencies
3. Unnatural lesion appearance or placement
4. Ruler or other generative artifacts
5. Poor instruction following

Of the 185,400 total semantic synthetics, we include 60,255 (~33%) in classification experiments (those from diseases with >10 training samples). All synthetics are published regardless of training sample count for further study.

---

### S3. Training Hyperparameters

#### S3.1 Latent Diffusion Inpainting

The inpainting pipeline uses a frozen UNet denoiser (1.22B parameters) and MoVQGAN decoder (67M parameters). No training is required.

- **Positive prompt:** "A close-up clinical photograph of healthy, smooth, normal human skin"
- **Negative prompt:** "Bad anatomy, deformed, lesion, ugly, disfigured, illness, hole, transparent, eye"
- **Mask processing:** Dilation with kernel size 5, followed by Gaussian blur with σ = 2.0

We ablated various prompt combinations. Removing "healthy, smooth, normal" from the positive prompt leads to anatomically incorrect generation. Excluding "hole, transparent" or "eye" from the negative prompt yields common artifacts (holes in skin, eye generation). The optimal combination above provided the best balance of realistic skin texture.

#### S3.2 Lesion Mapping Parameters

The lesion mapping algorithm is non-parametric.

| Parameter | Value | Description |
|---|---|---|
| Location (l) | Random | Random placement within valid skin region given padding |
| Padding (p) | 10 pixels | Minimum distance from lesion edge to skin mask edge |
| Scale (s) | 1.0 | No up/down-scaling applied |
| Rotation (r) | 0° | No rotation applied |

#### S3.3 Textual Inversion

| Parameter | Value |
|---|---|
| Batch size | 4 |
| Max training steps | 500 |
| Learning rate | 5.0e−4 |
| Initializer token | "skin" |
| Precision | fp16 |
| LR schedule | Constant (no warm-up) |

#### S3.4 LoRA Fine-tuning

| Parameter | Value |
|---|---|
| Batch size | 16 |
| Sampling batch size | 16 |
| Gradient accumulation steps | 1 |
| Max training steps | 750 |
| Learning rate | 5.0e−6 |
| Class images | Healthy synthetics |
| Precision | fp16 |
| LR schedule | Constant (no warm-up) |

#### S3.5 Semantic Sampling Parameters

| Parameter | Value |
|---|---|
| Conditioning strength (α) | 0.725 |
| Guidance scale (β) | 8.75 |
| Inference steps (t) | 100 |

Setting α much lower than 0.7 struggles to guide generation toward the prompted skin tone.

---

### S4. Skin-Tone Balance

We measure imbalance using the Imbalance Ratio (IR):

> IR = max_k(n_k) / min_k(n_k)

where n_k is the number of samples of skin-tone k. A perfectly balanced set has IR = 1.

| Dataset | Light (I–II) | Medium (III–IV) | Dark (V–VI) | Imbalance Ratio |
|---|---|---|---|---|
| F17k | 7,755 | 6,089 | 2,168 | 3.58 |
| SCIN | 730 | 1,088 | 357 | 3.05 |
| DDI | 208 | 241 | 207 | 1.16 |
| cgDDI Healthy | 97 | 114 | 98 | 1.18 |
| cgDDI Lesion-mapped | 25,726 | 30,392 | 24,309 | 1.25 |
| cgDDI Semantic | 61,800 | 61,800 | 61,800 | 1.00 |

Our sampling methods do not introduce significant imbalance compared to DDI, and improve substantially upon other real datasets.

---

### S5. Data Efficiency Ablation

To determine the minimum number of real samples for effective generation, we ablated generation quality as a function of training sample count via visual observation of random subsets.

Generation quality improves significantly up to approximately 10 samples, after which gains become incremental. Specifically we note improvement in:

- Human anatomy realism
- Valid clinical ruler appearance
- Lesion morphology (isolation of target disease, rather than generating multiple lesions)
- Instruction following (correct skin tone, correct disease)

We determine our approach is effective with as few as 10 real training samples per disease class.

---

### S6. Generative Quality by Method

We provide FID, KID, and LPIPS stratified by generation method and skin tone:

| Metric | Method | Light | Medium | Dark | σ |
|---|---|---|---|---|---|
| FID ↓ | Healthy | 94.02 | 92.11 | 121.33 | 13.35 |
| FID ↓ | Lesion-mapped | 72.75 | 69.46 | 96.99 | 12.28 |
| FID ↓ | Semantic | 134.67 | 124.94 | 131.95 | 4.10 |
| KID ↓ | Healthy | 0.012 | 0.008 | 0.010 | 0.001 |
| KID ↓ | Lesion-mapped | 0.005 | 0.003 | 0.001 | 0.002 |
| KID ↓ | Semantic | 0.055 | 0.069 | 0.037 | 0.013 |
| LPIPS ↓ | Healthy | 0.703 | 0.692 | 0.700 | 0.005 |
| LPIPS ↓ | Lesion-mapped | 0.703 | 0.692 | 0.698 | 0.005 |
| LPIPS ↓ | Semantic | 0.738 | 0.756 | 0.743 | 0.008 |

**Lesion-mapped** (non-parametric) achieves the strongest distributional alignment (best mean FID of 79.73, best mean KID of 0.003). **Healthy** synthetics come second in FID and KID with strong perceptual similarity. **Semantic** (parametric) shows the most tone consistency on FID (σ = 4.10) but the largest divergence from base DDI as a fully learned approach. No systematic advantage for any skin tone is observed.

---

### S7. Cross-Dataset Synthesis Totals

#### S7.1 F17k Processing

Using SAMv3 for automated masking on the expert-verified F17k subset (364 samples):
- **Healthy synthetics:** 46 (21 light, 16 medium, 9 dark)
- **Lesion-mapped synthetics:** 1,124 (529 light, 373 medium, 222 dark) — 46.9% discard rate
- **Semantic synthetics:** 5,520 (1,840 per skin tone) — all 8 F17k conditions have >10 training samples

The higher discard rate compared to DDI is attributable to imperfect automated masks.

#### S7.2 Cross-Dataset Lesion Mapping

| Direction | Total | Light | Medium | Dark |
|---|---|---|---|---|
| DDI lesions → F17k healthy | 13,822 | 6,593 | 4,267 | 2,962 |
| F17k lesions → DDI healthy | 9,394 | 3,103 | 3,272 | 3,019 |

#### S7.3 Cross-Dataset Semantic Generation

| Configuration | Total Images | Per Skin Tone |
|---|---|---|
| F17k diseases + DDI healthy prompts | 37,080 | 12,360 |
| DDI diseases + F17k healthy prompts | 8,970 | 2,990 |

---

### S8. Transformative Use

To contextualize that cgDDI produces substantially novel imagery (rather than simple modifications), we compare FID scores between standard augmentations and our methods against base DDI:

| Method | FID ↓ |
|---|---|
| Duplication | 0.0 |
| Color Edits | 3.8 |
| Contrast | 7.3 |
| Rotation | 17.3 |
| Random Cropping | 23.0 |
| Gaussian Noise | 32.1 |
| cgDDI Lesion-mapped | 79.7 |
| cgDDI Healthy | 102.5 |
| cgDDI Semantic | 130.5 |

The significantly larger FID scores (≥79.7) demonstrate that cgDDI creates substantially novel imagery, supporting the transformative nature of our contribution.

---

### S9. Compute Resources

| Component | Approximate Time |
|---|---|
| Healthy synthetic generation | 2.5 GPU hours |
| Lesion mapping | 30 CPU hours |
| Textual inversion training | 45 GPU hours |
| LoRA fine-tuning | 30 GPU hours |
| Semantic synthetic generation | 250 GPU days |
| Classification experiments | 10 GPU hours |

**Total:** ~6,000 GPU hours across multiple compute instances.

**Hardware:** NVIDIA L4 24GB, Intel Xeon @ 2.20GHz, 53GB RAM, 112.6GB storage.

**Software:** Ubuntu 22.04.4, CUDA 12.4, Python 3.11.12. Additional dependencies leverage Google Colab pre-installed libraries; all extras are documented in the code.

---

### S10. Ethics and Data Use

- **IRB:** Experiments use de-identified, biopsy-confirmed clinical photographs from DDI, collected under Stanford IRB protocols 36050 and 61146. No new human-subjects data was collected.
- **Review demographics:** Manual review was performed by two researchers in Medical AI—one Hispanic/Latino man and one Middle-Eastern woman.
- **Fairness:** cgDDI explicitly balances across Fitzpatrick I–VI and augments extremely rare conditions. Generative quality is stratified by skin tone to confirm equity.
- **Artifacts:** We release only our original artifacts (synthesized data, models, code) under CC BY-NC. We do not distribute original clinical images.
- **Dual-use:** Synthetic medical images could be misused for deceptive content. We provide safeguards: clear labeling and strict intended-use terms. No clinical deployment is claimed.
- **Conflicts of interest:** None. Our work aims to democratize access to fair dermatological AI research.

---

### S11. Classification Experiment Details

- **Architecture:** ViT-B/16 pre-trained on ImageNet-21k, following PatchAlign.
- **Optimizer:** Adam, learning rate 1e−4, linear decay (step size 2, decay factor 0.8).
- **Batch size:** 32, trained for 20 epochs.
- **Fine-tuning (Exp. 2):** Learning rate 1e−5, additional 20 epochs with early stopping.
- **Cross-validation:** Five-fold using seeds [36, 37, 38, 39, 40] from PatchAlign.
- **Data split:** 80/20 train/test ratio.
- **Leakage prevention:** Excludes lesion-mapped synthetics generated from test-set donors and semantic synthetics whose (disease, healthy prompt) pair reconstructs a test image.

---

## Models

Models will be released upon acceptance due to the difficulty of hosting them fully anonymously. All information needed to retrain them is provided in this repository and the supplementary sections above.

---

## Usage Terms

We release this data, code, and models with the intent of academic use and to promote fairness research. We do not allow unethical usage of these artifacts.

---

## Acknowledgements

We thank HuggingFace Transformers for their implementations of many popular methods, [Skin-Diff](https://github.com/janet-sw/skin-diff/tree/main), [FairDisCo](https://github.com/siyi-wind/FairDisCo), and [PatchAlign](https://github.com/aayushmanace/PatchAlign24) for providing a base upon which we build this repo.
