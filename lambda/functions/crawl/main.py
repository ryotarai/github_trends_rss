from lxml import html
import cssselect
import requests
from feedgen.feed import FeedGenerator
import boto3
import json

sqs = boto3.resource('sqs')
s3 = boto3.resource('s3')
bucket = 'github-trends.ryotarai.info'
queue_name = 'github_trends_worker'

def handle(event, context):
    page = requests.get('https://github.com/trending')
    tree = html.fromstring(page.content)

    languages = []
    languages.append({"url": "https://github.com/trending", "name": "All languages", "key": "all"})
    languages.append({"url": "https://github.com/trending/unknown", "name": "Unknown", "key": "unknown"})
    aa = tree.cssselect("div.select-menu-list")[1].cssselect("a")
    for a in aa:
        url = a.get("href")
        key = url.split("/")[-1]
        languages.append({"url": url, "name": a.cssselect("span")[0].text, "key": key})

    s3.Object(bucket, "languages.json").put(Body=json.dumps(languages), ContentType="application/json")
    queue = sqs.get_queue_by_name(QueueName=queue_name)
    for since in ["daily", "weekly", "monthly"]:
        for language in languages:
            body = json.dumps({"language": language, "since": since})
            print(body)
            queue.send_message(MessageBody=body)

if __name__ == '__main__':
    handle(None, None)

