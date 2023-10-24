#!/bin/bash

set -x

export model_size=30B
source run_scripts/gpt/base_env.sh
export max_new_tokens=${1}
export lora=${2}
export max_seq_len=$(( max_new_tokens*2 ))


if [[ "$lora" == "True" ]]; then
    [ -z "$policy_tp" ] && export policy_tp=8
    [ -z "$ppo_policy_pp" ] && export ppo_policy_pp=2
    [ -z "$reward_tp" ] && export reward_tp=8
    [ -z "$ppo_value_pp" ] && export ppo_value_pp=2
    if [[ "$max_new_tokens" == "512" ]]; then
        export num_device_ref=16
        export num_device_value=16
        export ref_pp=2
        export reward_pp=2
        export num_device_ppo_policy=16
        export num_device_ppo_value=16
        export batch_generation_min_prompt_length=32
	      [ -z "$inference_batch_times_seqlen_threshold" ] && export inference_batch_times_seqlen_threshold=4096
        [ -z "$policy_generation_batch_size" ] && export policy_generation_batch_size=256
        [ -z "$ref_generation_bs" ] && export ref_generation_bs=256
        [ -z "$value_generation_bs" ] && export value_generation_bs=64
        [ -z "$reward_generation_bs" ] && export reward_generation_bs=256
        [ -z "$train_micro_batch_size" ] && export train_micro_batch_size=8
        [ -z "$train_global_batch_size" ] && export train_global_batch_size=512
    fi
else
    [ -z "$policy_tp" ] && export policy_tp=8
    [ -z "$ppo_policy_pp" ] && export ppo_policy_pp=4
    [ -z "$reward_tp" ] && export reward_tp=8
    [ -z "$ppo_value_pp" ] && export ppo_value_pp=4
    if [[ "$max_new_tokens" == "512" ]]; then
        export num_device_ref=16
        export num_device_value=16
        export ref_pp=2
        export reward_pp=2
        export batch_generation_min_prompt_length=32
	      [ -z "$inference_batch_times_seqlen_threshold" ] && export inference_batch_times_seqlen_threshold=4096
        [ -z "$policy_generation_batch_size" ] && export policy_generation_batch_size=86
        [ -z "$ref_generation_bs" ] && export ref_generation_bs=86
        [ -z "$value_generation_bs" ] && export value_generation_bs=32
        [ -z "$reward_generation_bs" ] && export reward_generation_bs=86
        [ -z "$train_micro_batch_size" ] && export train_micro_batch_size=4
        [ -z "$train_global_batch_size" ] && export train_global_batch_size=512
    fi
fi

bash run_scripts/gpt/benchmark.sh

set +x
