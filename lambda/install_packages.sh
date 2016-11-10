docker run -it 137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest -v $(pwd):/work /bin/bash -c '
yum install -y python27-pip python27-devel gcc libxml2-devel libxslt-devel &&
cd /work/functions/crawl &&
pip install --upgrade pip &&
/usr/local/bin/pip install -r requirements.txt -t .
'
