docker run -it 137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest -v $(pwd):/work /bin/bash -c '
yum install -y python27-pip python27-devel gcc libxml2-devel libxslt-devel &&
pip install --upgrade pip &&
cd /work/functions/crawl &&
/usr/local/bin/pip install -r requirements.txt -t . &&
cd /work/functions/worker &&
/usr/local/bin/pip install -r requirements.txt -t .
'
