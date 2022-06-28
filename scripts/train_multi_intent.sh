
DIR=$(pwd)
DATA=${DIR}/data
MODEL=${DIR}/model
RES=${DIR}/res



for TASK in MultiIntent_single_stage
do
    model_name='facebook/mbart-large-cc25'

    cd /mnt/bd/zhengxinvolume/transformers/examples/pytorch/summarization
    python3 -m torch.distributed.launch --nproc_per_node=4 --master_port=12345  run_summarization.py \
        --model_name_or_path ${model_name} \
        --do_train \
        --do_eval \
        --do_predict \
        --train_file ${DATA}/${TASK}/train.json \
        --validation_file ${DATA}/${TASK}/dev.json \
        --test_file ${DATA}/${TASK}/test.json \
        --output_dir ${MODEL}/${TASK}_${model_name} \
        --overwrite_output_dir \
        --num_train_epochs 8 \
        --overwrite_cache \
        --per_device_train_batch_size=24 \
        --per_device_eval_batch_size=4 \
        --evaluation_strategy epoch \
        --predict_with_generate \
        --generation_num_beams 4 \
        --learning_rate 3e-5 \
        --save_strategy no \
        --warmup_steps 50 \
        --logging_steps 500 \
        --sharded_ddp simple \
        --lang 'zh_CN'
    rm -rf ${MODEL}/${TASK}_${model_name}/checkpoint*
    cd /mnt/bd/zhengxinvolume/AGIF
    python3 tools/eval_multi_intent_exact_match.py  --pred_file ${MODEL}/${TASK}_${model_name}/generated_predictions.txt >> ${RES}/multi_intent_exact_match.txt &
    python3 tools/eval_sacc.py --ref_file ${DATA}/${TASK}/test.ref  --pred_file ${MODEL}/${TASK}_${model_name}/generated_predictions.txt >> ${RES}/sacc.txt

    cd /mnt/bd/zhengxinvolume/e2e-metrics
    ./measure_scores.py -t ${DATA}/${TASK}/test.ref ${MODEL}/${TASK}_${model_name}/generated_predictions.txt >> ${RES}/BLEU.txt &

done


for TASK in MultiIntent_single_stage 
do
for model_name in google/mt5-base google/mt5-large google/mt5-xl 
do
    cd /mnt/bd/zhengxinvolume/transformers/examples/pytorch/summarization
    python3 -m torch.distributed.launch --nproc_per_node=4 --master_port=12345  run_summarization.py \
        --model_name_or_path ${model_name} \
        --do_train \
        --do_eval \
        --do_predict \
        --train_file ${DATA}/${TASK}/train.json \
        --validation_file ${DATA}/${TASK}/dev.json \
        --test_file ${DATA}/${TASK}/test.json \
        --output_dir ${MODEL}/${TASK}_${model_name} \
        --overwrite_output_dir \
        --num_train_epochs 9 \
        --overwrite_cache \
        --per_device_train_batch_size=24 \
        --per_device_eval_batch_size=4 \
        --evaluation_strategy epoch \
        --predict_with_generate \
        --generation_num_beams 4 \
        --learning_rate 3e-5 \
        --save_strategy no \
        --warmup_steps 50 \
        --logging_steps 500 \
        --sharded_ddp simple 
    rm -rf ${MODEL}/${TASK}_${model_name}/checkpoint*
    cd /mnt/bd/zhengxinvolume/AGIF
    python3 tools/eval_multi_intent_exact_match.py  --pred_file ${MODEL}/${TASK}_${model_name}/generated_predictions.txt >> ${RES}/multi_intent_exact_match.txt &
    python3 tools/eval_sacc.py --ref_file ${DATA}/${TASK}/test.ref  --pred_file ${MODEL}/${TASK}_${model_name}/generated_predictions.txt >> ${RES}/sacc.txt

    cd /mnt/bd/zhengxinvolume/e2e-metrics
    ./measure_scores.py -t ${DATA}/${TASK}/test.ref ${MODEL}/${TASK}_${model_name}/generated_predictions.txt >> ${RES}/BLEU.txt &

done
done
