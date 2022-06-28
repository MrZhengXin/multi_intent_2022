import json
from argparse import ArgumentParser


def read_json(file_name):
    with open(file_name, 'r', encoding='utf-8') as f:
        json_list = f.readlines()
    json_list = [json.loads(instance) for instance in json_list]
    return json_list


parser = ArgumentParser()
parser.add_argument("--first_stage_pred", type=str, default='model/MultiIntent_first_stage_google/mt5-base/generated_predictions.txt')
parser.add_argument("--second_stage_dir", type=str, default='data/MultiIntent_second_stage_causal/')
args = parser.parse_args()

with open(args.first_stage_pred, 'r') as f:
    pred_list = f.readlines()


instance_list = read_json(args.second_stage_dir + 'test.json')
fw = open(args.second_stage_dir + 'test_by_first_stage.json', 'w', encoding='utf-8')
j = -1

for pred in pred_list:
    pred_split = pred.strip()[:-1].split(';')
    cnt_split = len(pred_split)
    for j in range(cnt_split):
        text = ';'.join(pred_split[:j+1]) + ';'
        print(json.dumps({'text': text, 'summary': pred_split[j]}, ensure_ascii=False), file=fw)
