# cgDDI Repository

This repository is the official implementation of **cgDDI: Controllable Generation of Diverse Dermatological Imagery for Fair and Efficient Malignancy Classification** which is currently under review. As this paper is not openly distributed (or on Arxiv), the method detail here will be minimal.

**NOTE:** As the notebooks include visualized results, they may not load direclty on github, please open locally (or on colab) if this happens. The code was originally run on Colab, which comes with the majority of requirements, if the base colab image does not contain a requirement, the notebook includes a `!pip install` call with any missing packages.

## Dataset

Our dataset can be found on https://huggingface.co/datasets/hcarrion/ControllabeGenDDI

## Healthy Synthetics

To generate healthy synthetics please run `healthy_gen.ipynb`.

We do not re-host previous artifacts, thus remember to **fetch the original DDI dataset** at https://ddi-dataset.github.io/ and the **sDDI masks from** https://github.com/hectorcarrion/FEDD.

## Lession Mapping Synthetics

To generate lesion mapped images please run `lession_mapping.ipynb`

## Textual Inversion

To train the Textual Inversion model please run `textual_inversion.ipynb`.
Note that you must provide a CSV of the downloaded DDI data you fetched in the previous step, with disease mapping from the original data (if desired) as included on the notebook.

## LoRA fine-tuning

To fine-tune with your text-inversion disease special tokens, please run `train_lora.ipynb`

## Semantic Synthetics

To sample semantic synthetics, please run `semantic_sampling.ipynb`

## Classificaiton and Fairness

To run classification experiments please see https://github.com/aayushmanace/PatchAlign24
Download cgDDI data and csv, replace input directories with these directories. Ensure to drop any rows of lession-mapped imagery which has been generated with prompts inside the test set.

Thanks for reading! More detail and code cleanup to be added overtime as the paper and method become public

## Models

Models can be found at the following links:

1. https://huggingface.co/hcarrion/xanthogranuloma
2. https://huggingface.co/hcarrion/verruciform_xanthoma
3. https://huggingface.co/hcarrion/verruca_vulgaris
4. https://huggingface.co/hcarrion/trichofolliculoma
5. https://huggingface.co/hcarrion/trichilemmoma
6. https://huggingface.co/hcarrion/traumatic_injury
7. https://huggingface.co/hcarrion/tinea_pedis
8. https://huggingface.co/hcarrion/syringocystadenoma_papilliferum
9. https://huggingface.co/hcarrion/squamous_cell_carcinoma
10. https://huggingface.co/hcarrion/spindle_cell_nevus_of_Reed
11. https://huggingface.co/hcarrion/solar_lentigo
12. https://huggingface.co/hcarrion/seborrheic_keratosis
13. https://huggingface.co/hcarrion/sebaceous_carcinoma
14. https://huggingface.co/hcarrion/morphea
15. https://huggingface.co/hcarrion/scar
16. https://huggingface.co/hcarrion/reactive_lymphoid_hyperplasia
17. https://huggingface.co/hcarrion/pyogenic_granuloma
18. https://huggingface.co/hcarrion/prurigo_nodularis
19. https://huggingface.co/hcarrion/onychomycosis
20. https://huggingface.co/hcarrion/nevus_lipomatosus_superficialis
21. https://huggingface.co/hcarrion/nevus
22. https://huggingface.co/hcarrion/neuroma
23. https://huggingface.co/hcarrion/neurofibroma
24. https://huggingface.co/hcarrion/molluscum_contagiosum
25. https://huggingface.co/hcarrion/metastatic_carcinoma
26. https://huggingface.co/hcarrion/melanoma
27. https://huggingface.co/hcarrion/lymphocytic_infiltrations
28. https://huggingface.co/hcarrion/lipoma
29. https://huggingface.co/hcarrion/lichenoid_keratosis
30. https://huggingface.co/hcarrion/leukemia_cutis
31. https://huggingface.co/hcarrion/keloid
32. https://huggingface.co/hcarrion/kaposi_sarcoma
33. https://huggingface.co/hcarrion/hyperpigmentation
34. https://huggingface.co/hcarrion/hematoma
35. https://huggingface.co/hcarrion/graft-vs-host_disease
36. https://huggingface.co/hcarrion/glomangioma
37. https://huggingface.co/hcarrion/foreign_body_granuloma
38. https://huggingface.co/hcarrion/folliculitis
39. https://huggingface.co/hcarrion/focal-acral-hyperkeratosis
40. https://huggingface.co/hcarrion/fibrous_papule
41. https://huggingface.co/hcarrion/epidermal_nevus
42. https://huggingface.co/hcarrion/epidermal_cyst
43. https://huggingface.co/hcarrion/atopic_dermatitis
44. https://huggingface.co/hcarrion/eccrine_poroma
45. https://huggingface.co/hcarrion/dermatomyositis
46. https://huggingface.co/hcarrion/dermatofibroma
47. https://huggingface.co/hcarrion/cutaneous_T-cell_lymphoma
48. https://huggingface.co/hcarrion/condyloma_acuminatum
49. https://huggingface.co/hcarrion/coccidioidomycosis
50. https://huggingface.co/hcarrion/clear_cell_acanthoma
51. https://huggingface.co/hcarrion/chondroid_syringoma
52. https://huggingface.co/hcarrion/cellular_neurothekeoma
53. https://huggingface.co/hcarrion/blue_nevus
54. https://huggingface.co/hcarrion/blastic_plasmacytoid_dendritic_cell_neoplasm
55. https://huggingface.co/hcarrion/benign_keratosis
56. https://huggingface.co/hcarrion/basal_cell_carcinoma
57. https://huggingface.co/hcarrion/arteriovenous_hemangioma
58. https://huggingface.co/hcarrion/angioma
59. https://huggingface.co/hcarrion/angioleiomyoma
60. https://huggingface.co/hcarrion/actinic_keratosis
61. https://huggingface.co/hcarrion/acrochordon
62. https://huggingface.co/hcarrion/acral_melanotic_macule
63. https://huggingface.co/hcarrion/acquired_digital_fibrokeratoma
64. https://huggingface.co/hcarrion/acne-cystic
65. https://huggingface.co/hcarrion/abscess

## Usage Terms
We release this data, code and models with the intent of academic use and to promote fairness research. We do not allow un-ethical usage of these artifacts.

## Acknoledgements

We thank HuggingFace Transformers for their implementations of many popular methods, [Skin-Diff](https://github.com/janet-sw/skin-diff/tree/main), [FairDisCo](https://github.com/siyi-wind/FairDisCo) and [PathAlign](https://github.com/aayushmanace/PatchAlign24) for providing a base upon which we build this repo.
