# cgDDI Repository

This repository is the official implementation of **cgDDI: Controllable Generation of Diverse Dermatological Imagery for Fair and Efficient Malignancy Classification** which is currently under review. As this paper is not currently on Arxiv, the detail here will be minimal.

## Healthy Synthetics

To generate healthy synthetics please run `healthy_gen.ipynb`.

We do not re-host previous artifacts, thus remember to **fetch the original DDI dataset** at https://ddi-dataset.github.io/ and the **sDDI masks from** https://github.com/hectorcarrion/FEDD.

## Textual Inversion

To train the Textual Inversion model please run `textual_inversion.ipynb`.
Note that you must provide a CSV of the downloaded DDI data you fetched in the previous step, with this disease mapping from the original data (if desired).
```
# Mapping for the DDI dataset (labels in ddi_df['disease'])
ddi_mapping = {
    # Melanoma group: various melanoma subtypes → "melanoma"
    'melanoma-in-situ': 'melanoma',
    'melanoma-acral-lentiginous': 'melanoma',
    'nodular-melanoma-(nm)': 'melanoma',
    'melanoma': 'melanoma',
    # Basal cell carcinoma group
    'basal-cell-carcinoma': 'basal cell carcinoma',
    'basal-cell-carcinoma-superficial': 'basal cell carcinoma',
    'basal-cell-carcinoma-nodular': 'basal cell carcinoma',
    # Squamous cell carcinoma group
    'squamous-cell-carcinoma-in-situ': 'squamous cell carcinoma',
    'squamous-cell-carcinoma': 'squamous cell carcinoma',
    'squamous-cell-carcinoma-keratoacanthoma': 'squamous cell carcinoma',
    # Cutaneous T-cell lymphoma group (mycosis fungoides is the most common type)
    'mycosis-fungoides': 'cutaneous T-cell lymphoma',
    'subcutaneous-t-cell-lymphoma': 'cutaneous T-cell lymphoma',
    # Seborrheic keratosis group
    'seborrheic-keratosis-irritated': 'seborrheic keratosis',
    'seborrheic-keratosis': 'seborrheic keratosis',
    # Nevi group
    'melanocytic-nevi': 'nevus',
    'dysplastic-nevus': 'nevus',
    # Other lesions: map one-to-one or group similar lesions by morphology
    'foreign-body-granuloma': 'foreign body granuloma',
    'blue-nevus': 'blue nevus',
    'verruca-vulgaris': 'verruca vulgaris',
    'wart': 'verruca vulgaris',
    'acrochordon': 'acrochordon',
    'abrasions-ulcerations-and-physical-injuries': 'traumatic injury',
    'epidermal-cyst': 'epidermal cyst',
    'acquired-digital-fibrokeratoma': 'acquired digital fibrokeratoma',
    'epidermal-nevus': 'epidermal nevus',
    'trichilemmoma': 'trichilemmoma',
    'pyogenic-granuloma': 'pyogenic granuloma',
    'neurofibroma': 'neurofibroma',
    'syringocystadenoma-papilliferum': 'syringocystadenoma papilliferum',
    'nevus-lipomatosus-superficialis': 'nevus lipomatosus superficialis',
    'benign-keratosis': 'benign keratosis',
    'inverted-follicular-keratosis': 'benign keratosis',
    'onychomycosis': 'onychomycosis',
    'dermatofibroma': 'dermatofibroma',
    'trichofolliculoma': 'trichofolliculoma',
    'lymphocytic-infiltrations': 'lymphocytic infiltrations',
    'prurigo-nodularis': 'prurigo nodularis',
    'kaposi-sarcoma': 'kaposi sarcoma',
    'scar': 'scar',
    'eccrine-poroma': 'eccrine poroma',
    'angioleiomyoma': 'angioleiomyoma',
    'hematoma': 'hematoma',
    'metastatic-carcinoma': 'metastatic carcinoma',
    'angioma': 'angioma',
    'folliculitis': 'folliculitis',
    # Spindle cell nevus of Reed has multiple name variants
    'atypical-spindle-cell-nevus-of-reed': 'spindle cell nevus of Reed',
    'pigmented-spindle-cell-nevus-of-reed': 'spindle cell nevus of Reed',
    'xanthogranuloma': 'xanthogranuloma',
    # Eczema: map the spongiotic dermatitis to the eczema/atopic dermatitis group
    'eczema-spongiotic-dermatitis': 'eczema/atopic dermatitis',
    'arteriovenous-hemangioma': 'arteriovenous hemangioma',
    'verruciform-xanthoma': 'verruciform xanthoma',
    'molluscum-contagiosum': 'molluscum contagiosum',
    'condyloma-accuminatum': 'condyloma acuminatum',
    # Group localized scleroderma with systemic scleroderma if appearance is similar
    'morphea': 'scleroderma/morphea',
    'neuroma': 'neuroma',
    'actinic-keratosis': 'actinic keratosis',
    'glomangioma': 'glomangioma',
    'cellular-neurothekeoma': 'cellular neurothekeoma',
    'fibrous-papule': 'fibrous papule',
    'graft-vs-host-disease': 'graft-vs-host disease',
    'lichenoid-keratosis': 'lichenoid keratosis',
    'reactive-lymphoid-hyperplasia': 'reactive lymphoid hyperplasia',
    'coccidioidomycosis': 'coccidioidomycosis',
    'leukemia-cutis': 'leukemia cutis',
    'sebaceous-carcinoma': 'sebaceous carcinoma',
    'chondroid-syringoma': 'chondroid syringoma',
    'tinea-pedis': 'tinea pedis',
    'solar-lentigo': 'solar lentigo',
    'clear-cell-acanthoma': 'clear cell acanthoma',
    'abscess': 'abscess',
    'blastic-plasmacytoid-dendritic-cell-neoplasm': 'blastic plasmacytoid dendritic cell neoplasm',
    'acral-melanotic-macule': 'acral melanotic macule'
}
```

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
