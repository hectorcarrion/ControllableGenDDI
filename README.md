# cgDDI Repository

This repository is the official implementation of **cgDDI: Controllable Generation of Diverse Dermatological Imagery for Fair and Efficient Malignancy Classification** which is currently under review. As this paper is not currently on Arxiv, the detail here will be minimal.

**NOTE:** As the notebooks include visualized results, they may not load direclty on github, please open locally (or on colab) if this happens.

## Healthy Synthetics

To generate healthy synthetics please run `healthy_gen.ipynb`.

We do not re-host previous artifacts, thus remember to **fetch the original DDI dataset** at https://ddi-dataset.github.io/ and the **sDDI masks from** https://github.com/hectorcarrion/FEDD.

## Textual Inversion

To train the Textual Inversion model please run `textual_inversion.ipynb`.
Note that you must provide a CSV of the downloaded DDI data you fetched in the previous step, with disease mapping from the original data (if desired) as included on the notebook.

## Evaluation

To evaluate my model on ImageNet, run:

```eval
python eval.py --model-file mymodel.pth --benchmark imagenet
```

>📋  Describe how to evaluate the trained models on benchmarks reported in the paper, give commands that produce the results (section below).

## Pre-trained Models

You can download pretrained models here:

- [My awesome model](https://drive.google.com/mymodel.pth) trained on ImageNet using parameters x,y,z. 

>📋  Give a link to where/how the pretrained models can be downloaded and how they were trained (if applicable).  Alternatively you can have an additional column in your results table with a link to the models.

## Results

Our model achieves the following performance on :

### [Image Classification on ImageNet](https://paperswithcode.com/sota/image-classification-on-imagenet)

| Model name         | Top 1 Accuracy  | Top 5 Accuracy |
| ------------------ |---------------- | -------------- |
| My awesome model   |     85%         |      95%       |

>📋  Include a table of results from your paper, and link back to the leaderboard for clarity and context. If your main result is a figure, include that figure and link to the command or notebook to reproduce it. 


## Contributing

>📋  Pick a licence and describe how to contribute to your code repository. 
