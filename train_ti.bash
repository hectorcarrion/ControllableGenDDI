#!/bin/bash

SEED=0
MODEL_NAME="stabilityai/stable-diffusion-2-1-base"
DATA_DIR="" # This is ok to leave blank, as we update textual_inversion.py to work with CSVs
DATA_SPLIT="./ddi_paths.csv" # path to the data
OUTPUT_DIR_BASE="./run_1" # path to the output model


DISEASES=("abscess" "acne-cystic" "acquired digital fibrokeratoma" "acral melanotic macule" \
          "acrochordon" "actinic keratosis" "angioleiomyoma" "angioma" \
          "arteriovenous hemangioma" "basal cell carcinoma" "benign keratosis" \
          "blastic plasmacytoid dendritic cell neoplasm" "blue nevus" "cellular neurothekeoma" \
          "chondroid syringoma" "clear cell acanthoma" "coccidioidomycosis" \
          "condyloma acuminatum" "cutaneous T-cell lymphoma" "dermatofibroma" \
          "dermatomyositis" "eccrine poroma" "eczema/atopic dermatitis" \
          "epidermal cyst" "epidermal nevus" "fibrous papule" "focal-acral-hyperkeratosis" \
          "folliculitis" "foreign body granuloma" "glomangioma" "graft-vs-host disease" \
          "hematoma" "hyperpigmentation" "kaposi sarcoma" "keloid" "leukemia cutis" \
          "lichenoid keratosis" "lipoma" "lymphocytic infiltrations" "melanoma" \
          "metastatic carcinoma" "molluscum contagiosum" "neurofibroma" "neuroma" "nevus" \
          "nevus lipomatosus superficialis" "onychomycosis" "prurigo nodularis" \
          "pyogenic granuloma" "reactive lymphoid hyperplasia" "scar" "scleroderma/morphea" \
          "sebaceous carcinoma" "seborrheic keratosis" "solar lentigo" "spindle cell nevus of Reed" \
          "squamous cell carcinoma" "syringocystadenoma papilliferum" "tinea pedis" \
          "traumatic injury" "trichilemmoma" "trichofolliculoma" "verruca vulgaris" \
          "verruciform xanthoma" "xanthogranuloma") # All diseases in DDI

for disease in "${DISEASES[@]}"; do
    safe_disease="${disease// /_}"  # Replace spaces with underscores
    OUTPUT_DIR="${OUTPUT_DIR_BASE}/SEED=${SEED}/${safe_disease}"

    if [ ! -d "$OUTPUT_DIR" ]; then
        mkdir -p "$OUTPUT_DIR"
    fi

    token="<${safe_disease}-class>"  # Use modified disease name in the token
    
    accelerate launch textual_inversion.py \
        --pretrained_model_name_or_path="$MODEL_NAME" \
        --train_data_dir="$DATA_DIR" \
        --fitz_split_csv="$DATA_SPLIT" \
        --learnable_property="object" \
        --placeholder_token="$token" \
        --initializer_token="skin" \
        --resolution=512 \
        --train_batch_size=4 \
        --gradient_accumulation_steps=4 \
        --mixed_precision="fp16" \
        --max_train_steps=500 \
        --learning_rate=5.0e-04 \
        --scale_lr \
        --lr_scheduler="constant" \
        --lr_warmup_steps=0 \
        --push_to_hub \
        --output_dir="$OUTPUT_DIR"
done
