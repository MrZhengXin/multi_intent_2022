import json
from argparse import ArgumentParser


def read_json(file_name):
    with open(file_name, 'r', encoding='utf-8') as f:
        json_list = f.readlines()
    json_list = [json.loads(instance) for instance in json_list]
    return json_list


parser = ArgumentParser()
parser.add_argument("--pred", type=str, default='model/MultiIntent_second_stage_causal_google/mt5-xl/generated_predictions.txt')
parser.add_argument("--test_file", type=str, default='data/MultiIntent_second_stage_causal/test_by_first_stage.json')
args = parser.parse_args()

with open(args.pred, 'r') as f:
    pred_list = f.readlines()



instance_list = read_json(args.test_file)
fw = open(args.pred[:-4] + '_merged.txt', 'w', encoding='utf-8')
for i, instance in enumerate(instance_list):
    cnt_q = len(instance['text'].split(';'))-1
    if cnt_q == 1 and i != 0:
        print(file=fw)
    print(pred_list.pop(0).strip(), end=';', file=fw)
