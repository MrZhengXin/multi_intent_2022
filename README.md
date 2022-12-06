# multi_intent_2022
Public repository associated with [DialogUSR: Complex Dialogue Utterance Splitting and Reformulation for Multiple Intent Detection, Findings of EMNLP 2022](https://arxiv.org/abs/2210.11279)

# Data
The original unsplit data is at [here](https://github.com/MrZhengXin/multi_intent_2022/blob/main/data/MultiIntent/data.xlsx), 
while the data for single stage is at [data/MultiIntent_second_stage_once/](https://github.com/MrZhengXin/multi_intent_2022/tree/main/data/MultiIntent_second_stage_once),
two stage at [data/MultiIntent_second_stage_once/](https://github.com/MrZhengXin/multi_intent_2022/tree/main/data/MultiIntent_second_stage_once),
and causal two stage at [data/MultiIntent_second_stage_causal/](https://github.com/MrZhengXin/multi_intent_2022/tree/main/data/MultiIntent_second_stage_causal)

# Setup
Install [evaluation tool](https://github.com/tuetschek/e2e-metrics) and [transformers](https://github.com/huggingface/transformers).
```
sh scripts/setup.sh
```

# Training
Single stage
```
sh scripts/train_multi_intent.sh
```
Two stage
```
sh scripts/train_two_stage.sh
```

# Citation
```
@article{DBLP:journals/corr/abs-2210-11279,
  author    = {Haoran Meng and
               Zheng Xin and
               Tianyu Liu and
               Zizhen Wang and
               He Feng and
               Binghuai Lin and
               Xuemin Zhao and
               Yunbo Cao and
               Zhifang Sui},
  title     = {DialogUSR: Complex Dialogue Utterance Splitting and Reformulation
               for Multiple Intent Detection},
  journal   = {CoRR},
  volume    = {abs/2210.11279},
  year      = {2022},
  url       = {https://doi.org/10.48550/arXiv.2210.11279},
  doi       = {10.48550/arXiv.2210.11279},
  eprinttype = {arXiv},
  eprint    = {2210.11279},
  timestamp = {Tue, 25 Oct 2022 14:25:08 +0200},
  biburl    = {https://dblp.org/rec/journals/corr/abs-2210-11279.bib},
  bibsource = {dblp computer science bibliography, https://dblp.org}
}
```
