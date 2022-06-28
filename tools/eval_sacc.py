import argparse


parser = argparse.ArgumentParser()
parser.add_argument('--ref_file', type=str, default='data/MultiIntent/test.ref')
parser.add_argument('--pred_file', type=str)

args = parser.parse_args()

with open(args.ref_file, 'r') as f:
    references = f.readlines()

with open(args.pred_file, 'r') as f:
    predictions = f.readlines()

total = len(predictions)
hit = 0
for pred, ref in zip(predictions, references):

    hit += 1 if len(pred.split(';')) == len(ref.split(';')) else 0

acc = hit / total
print(args.pred_file, acc, sep='\t')
