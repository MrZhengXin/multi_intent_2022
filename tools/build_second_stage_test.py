import json
from argparse import ArgumentParser


def read_json(file_name):
    with open(file_name, 'r', encoding='utf-8') as f:
        json_list = f.readlines()
    json_list = [json.loads(instance) for instance in json_list]
    return json_list


parser = ArgumentParser()
parser.add_argument("--first_stage_pred", type=str, default='model/MultiIntent_first_stage_google/mt5-xl/generated_predictions.txt')
parser.add_argument("--second_stage_dir", type=str, default='data/MultiIntent_second_stage_once/')
args = parser.parse_args()

with open(args.first_stage_pred, 'r') as f:
    pred_list = f.readlines()

instance_list = read_json(args.second_stage_dir + 'test.json')
fw = open(args.second_stage_dir + 'test_by_first_stage.json', 'w', encoding='utf-8')
for i, instance in enumerate(instance_list):
    instance['text'] = pred_list[i].strip()
    print(json.dumps(instance, ensure_ascii=False), file=fw)