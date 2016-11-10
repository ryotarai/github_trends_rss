#!/bin/sh
set -e
aws s3 cp public/ s3://github-trends.ryotarai.info --recursive --exclude "rss/.*"
