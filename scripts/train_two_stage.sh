
DIR=$(pwd)
DATA=$(pwd)/data
MODEL=$(pwd)/model
RES=$(pwd)/res

for model_name in google/mt5-base google/mt5-large google/mt5-xl 
do
    for TASK in MultiIntent_second_stage_causal
    do
        cd ${DIR}
        FIRST_STAGE_PRED_FILE=${MODEL}/MultiIntent_first_stage_${model_name}/generated_predictions.txt
        python3 tools/build_causal_second_stage_test.py --first_stage_pred ${FIRST_STAGE_PRED_FILE} --second_stage_dir ${DATA}/${TASK}/
        OUTPUT_DIR=${MODEL}/${TASK}_${model_name}
        cd ../transformers/examples/pytorch/summarization
        python3 -m torch.distributed.launch --nproc_per_node=4 --master_port=12345  run_summarization.py \
            --model_name_or_path ${model_name} \
            --do_train \
            --do_predict \
            --do_eval \
            --train_file ${DATA}/${TASK}/train.json \
            --validation_file ${DATA}/${TASK}/dev.json \
            --test_file ${DATA}/${TASK}/test_by_first_stage.json \
            --output_dir ${OUTPUT_DIR} \
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
        rm -rf ${OUTPUT_DIR}/checkpoint*
        cd ${DIR}
        PRED_FILE=${OUTPUT_DIR}/generated_predictions.txt
        python3 tools/merge_causal_pred.py --pred ${PRED_FILE} --test_file ${DATA}/${TASK}/test_by_first_stage.json
        PRED_FILE=${OUTPUT_DIR}/generated_predictions_merged.txt
        python3 tools/eval_multi_intent_exact_match.py  --pred_file ${PRED_FILE}  >> ${RES}/multi_intent_exact_match.txt &
        python3 tools/eval_sacc.py --ref_file ${DATA}/${TASK}/test.ref  --pred_file ${PRED_FILE} >> ${RES}/sacc.txt

        cd ../e2e-metrics
        ./measure_scores.py -t ${DATA}/${TASK}/test.ref ${PRED_FILE} >> ${RES}/BLEU.txt &

    done
done


for model_name in google/mt5-base google/mt5-large google/mt5-xl 
do
    for TASK in MultiIntent_first_stage
    do

        OUTPUT_DIR=${MODEL}/${TASK}_${model_name}
        cd ../transformers/examples/pytorch/summarization
        python3 -m torch.distributed.launch --nproc_per_node=4 --master_port=12345  run_summarization.py \
            --model_name_or_path ${model_name} \
            --do_train \
            --do_eval \
            --do_predict \
            --train_file ${DATA}/${TASK}/train.json \
            --validation_file ${DATA}/${TASK}/dev.json \
            --test_file ${DATA}/${TASK}/test.json \
            --output_dir ${OUTPUT_DIR} \
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
        rm -rf ${OUTPUT_DIR}/checkpoint*
        FIRST_STAGE_PRED_FILE=${OUTPUT_DIR}/generated_predictions.txt
    done


    for TASK in MultiIntent_second_stage_once
    do
        cd ${DIR}
        python3 tools/build_second_stage_test.py --first_stage_pred ${FIRST_STAGE_PRED_FILE} --second_stage_dir ${DATA}/${TASK}/
        OUTPUT_DIR=${MODEL}/${TASK}_${model_name}
        cd ../transformers/examples/pytorch/summarization
        python3 -m torch.distributed.launch --nproc_per_node=4 --master_port=12345  run_summarization.py \
            --model_name_or_path ${model_name} \
            --do_train \
            --do_predict \
            --do_eval \
            --train_file ${DATA}/${TASK}/train.json \
            --validation_file ${DATA}/${TASK}/dev.json \
            --test_file ${DATA}/${TASK}/test_by_first_stage.json \
            --output_dir ${OUTPUT_DIR} \
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
        rm -rf ${OUTPUT_DIR}/checkpoint*
        cd ${DIR}
        PRED_FILE=${OUTPUT_DIR}/generated_predictions.txt
        python3 tools/eval_multi_intent_exact_match.py  --pred_file ${PRED_FILE}  >> ${RES}/multi_intent_exact_match.txt &
        python3 tools/eval_sacc.py --ref_file ${DATA}/${TASK}/test.ref  --pred_file ${PRED_FILE} >> ${RES}/sacc.txt

        cd ../e2e-metrics
        ./measure_scores.py -t ${DATA}/${TASK}/test.ref ${PRED_FILE} >> ${RES}/BLEU.txt &

    done


    for TASK in MultiIntent_second_stage_causal
    do
        cd ${DIR}
        python3 tools/build_causal_second_stage_test.py --first_stage_pred ${FIRST_STAGE_PRED_FILE} --second_stage_dir ${DATA}/${TASK}/
        OUTPUT_DIR=${MODEL}/${TASK}_${model_name}
        cd ../transformers/examples/pytorch/summarization
        python3 -m torch.distributed.launch --nproc_per_node=4 --master_port=12345  run_summarization.py \
            --model_name_or_path ${model_name} \
            --do_train \
            --do_predict \
            --do_eval \
            --train_file ${DATA}/${TASK}/train.json \
            --validation_file ${DATA}/${TASK}/dev.json \
            --test_file ${DATA}/${TASK}/test_by_first_stage.json \
            --output_dir ${OUTPUT_DIR} \
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
        rm -rf ${OUTPUT_DIR}/checkpoint*
        cd ${DIR}
        PRED_FILE=${OUTPUT_DIR}/generated_predictions.txt
        python3 tools/merge_causal_pred.py --pred ${PRED_FILE} --test_file ${DATA}/${TASK}/test_by_first_stage.json
        PRED_FILE=${OUTPUT_DIR}/generated_predictions_merged.txt
        python3 tools/eval_multi_intent_exact_match.py  --pred_file ${PRED_FILE}  >> ${RES}/multi_intent_exact_match.txt &
        python3 tools/eval_sacc.py --ref_file ${DATA}/${TASK}/test.ref  --pred_file ${PRED_FILE} >> ${RES}/sacc.txt

        cd ../e2e-metrics
        ./measure_scores.py -t ${DATA}/${TASK}/test.ref ${PRED_FILE} >> ${RES}/BLEU.txt &

    done
done

