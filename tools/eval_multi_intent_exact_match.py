import argparse
import json


parser = argparse.ArgumentParser()
parser.add_argument('--ref_file', type=str, default='data/MultiIntent_second_stage_once/test.json')
parser.add_argument('--pred_file', type=str)

args = parser.parse_args()

with open(args.ref_file, 'r') as f:
    references = f.readlines()
references = [json.loads(r) for r in references]

with open(args.pred_file, 'r') as f:
    predictions = f.readlines()

total = 0
hit = 0
hit_rewritten, hit_complete = 0, 0
total_rewritten, total_complete = 0, 0

for pred, ref in zip(predictions, references):
    pred_split = pred.split(';')[:-1]
    q_modified_split = ref['summary'].split(';')[:-1]
    q_original_split = ref['text'].split(';')[:-1]
    total += len(q_modified_split)
    for j in range(min(len(q_modified_split), len(pred_split))):
        correct = True if pred_split[j] == q_modified_split[j] else False
        hit += 1 if correct else 0
        if q_modified_split == q_original_split:
            hit_complete += 1 if correct else 0
            total_complete += 1
        else:
            hit_rewritten += 1 if correct else 0
            total_rewritten += 1            

em_complete = hit_complete / total_complete
em_rewritten = hit_rewritten / total_rewritten
em = hit / total
print(args.pred_file, em_complete, em_rewritten, em, sep='\t')
