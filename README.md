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

## Semantic Syntheticssem

To sample semantic synthetics, please run `semantic_sampling.ipynb`

## Classificaiton and Fairness

To run classification experiments please see https://github.com/aayushmanace/PatchAlign24
Download cgDDI data and csv, replace input directories with these directories. Ensure to drop any rows of lession-mapped imagery which has been generated with prompts inside the test set.

Thanks for reading! More detail and code cleanup to be added overtime as the paper and method become public.
