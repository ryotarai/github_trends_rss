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

def generate_rss(language, since):
    url = "{0}?since={1}".format(language["url"], since)
    file_name = "github_trends_{0}_{1}.rss".format(language["key"], since)
    title = "GitHub Trends - {0} - {1}".format(language["name"], since.capitalize())

    print(url)
    page = requests.get(url)
    tree = html.fromstring(page.content)
    lis = tree.cssselect("ol.repo-list li")

    fg = FeedGenerator()
    fg.title(title)
    fg.link(href="http://github-trends.ryotarai.info/rss/{0}".format(file_name))
    fg.description(title)
    index = 1
    for li in lis:
        a = li.cssselect("h3 a")[0]
        description = ""
        ps = li.cssselect("p")
        if len(ps) > 0:
            description = ps[0].text_content().strip()

        fe = fg.add_entry()
        fe.link(href="https://github.com{0}".format(a.get("href")))
        fe.title("{0} (#{1} - {2} - {3})".format(
            a.text_content().strip().replace(" / ", "/"),
            index,
            language["name"],
            since.capitalize(),
        ))
        fe.description(description)
        index += 1
    rssfeed = fg.rss_str(pretty=True)
    s3.Object(bucket, 'rss/{0}'.format(file_name)).put(Body=rssfeed, ContentType="application/xml")

def handle(event, context):
    queue = sqs.get_queue_by_name(QueueName=queue_name)
    while True:
        messages = queue.receive_messages(VisibilityTimeout=300, MaxNumberOfMessages=10)
        if len(messages) == 0:
            return
        for message in messages:
            print(message.body)
            data = json.loads(message.body)
            generate_rss(data["language"], data["since"])
            message.delete()

if __name__ == '__main__':
    handle(None, None)
