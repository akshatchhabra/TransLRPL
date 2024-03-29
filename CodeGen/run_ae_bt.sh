#!/bin/bash
#SBATCH --job-name=preprocess
#SBATCH -o output_train_with_reload_csharp_ae_bt.txt
#SBATCH -e error_train_with_reload_csharp_ae_bt.txt
#SBATCH -p gypsum-titanx
#SBATCH -n 1
#SBATCH --gres=gpu:1
#SBATCH --mem=240000
#SBATCH --array=2

module load conda

conda activate transCoder_env

python codegen_sources/model/train.py \
--exp_name ae_bt \
--dump_path '/work/pi_adrozdov_umass_edu/transLRPL/final_dataset/dataset/train_data_dump' \
--data_path '/work/pi_adrozdov_umass_edu/transLRPL/final_dataset/dataset/train_dataset_json/XLM-syml' \
--split_data_accross_gpu local \
--bt_steps 'csharp_monolingual-ruby_monolingual-csharp_monolingual,ruby_monolingual-csharp_monolingual-ruby_monolingual' \
--ae_steps 'csharp_monolingual,ruby_monolingual'  \
--lambda_ae '0:1,30000:0.1,100000:0'  \
--add_eof_to_stream true \
--word_mask_keep_rand '0.8,0.1,0.1' \
--word_pred '0.15' \
--encoder_only false \
--n_layers 0 \
--n_layers_encoder 6 \
--n_layers_decoder 6 \
--emb_dim 1024 \
--n_heads 8 \
--lgs 'csharp_monolingual-ruby_monolingual' \
--max_vocab 64000 \
--gelu_activation false \
--roberta_mode false \
--reload_model '/work/pi_adrozdov_umass_edu/transLRPL/final_dataset/dataset/train_data_dump/mlm/6591254/best-valid_mlm_ppl.pth,/work/pi_adrozdov_umass_edu/transLRPL/final_dataset/dataset/train_data_dump/mlm/6591254/best-valid_mlm_ppl.pth' \
--reload_encoder_for_decoder true \
--amp 2 \
--fp16 true \
--batch_size 32 \
--bptt 512 \
--epoch_size 5000 \
--max_epoch 100000 \
--split_data_accross_gpu global \
--optimizer 'adam_inverse_sqrt,warmup_updates=10000,lr=0.0001,weight_decay=0.01' \
--save_periodic 1 

