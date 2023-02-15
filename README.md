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
@inproceedings{meng-etal-2022-dialogusr,
    title = "{D}ialog{USR}: Complex Dialogue Utterance Splitting and Reformulation for Multiple Intent Detection",
    author = "Meng, Haoran  and
      Xin, Zheng  and
      Liu, Tianyu  and
      Wang, Zizhen  and
      Feng, He  and
      Lin, Binghuai  and
      Zhao, Xuemin  and
      Cao, Yunbo  and
      Sui, Zhifang",
    booktitle = "Findings of the Association for Computational Linguistics: EMNLP 2022",
    month = dec,
    year = "2022",
    address = "Abu Dhabi, United Arab Emirates",
    publisher = "Association for Computational Linguistics",
    url = "https://aclanthology.org/2022.findings-emnlp.234",
    pages = "3214--3229",
    abstract = "While interacting with chatbots, users may elicit multiple intents in a single dialogue utterance. Instead of training a dedicated multi-intent detection model, we propose DialogUSR, a dialogue utterance splitting and reformulation task that first splits multi-intent user query into several single-intent sub-queries and then recovers all the coreferred and omitted information in the sub-queries. DialogUSR can serve as a plug-in and domain-agnostic module that empowers the multi-intent detection for the deployed chatbots with minimal efforts. We collect a high-quality naturally occurring dataset that covers 23 domains with a multi-step crowd-souring procedure. To benchmark the proposed dataset, we propose multiple action-based generative models that involve end-to-end and two-stage training, and conduct in-depth analyses on the pros and cons of the proposed baselines.",
}
```
