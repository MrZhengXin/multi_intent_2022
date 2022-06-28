pip install -r requirements.txt

cd ..
git clone https://github.com/tuetschek/e2e-metrics.git
cd e2e-metrics
sudo apt-get install default-jre
pip install -r requirements.txt
curl -L https://cpanmin.us | sudo perl - App::cpanminus  # install cpanm
sudo cpanm XML::Twig

cd ..
git clone https://github.com/huggingface/transformers.git
cd transformers
python3 setup.py install
wandb login