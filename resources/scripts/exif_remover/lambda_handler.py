import os
import logging
import json
import boto3
from PIL import Image

logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    logger.info(f"event: {json.dumps(event)}")
    logger.info(f"context: {context}")
    if event["detail"]["object"]["size"] < 256_000_000 and event["detail"]["object"]["key"].endswith(".jpg"):
        s3 = boto3.client("s3")
        bucket = event["detail"]["bucket"]["name"]
        key = event["detail"]["object"]["key"]
        logger.info(f"bucket: {bucket}")
        logger.info(f"key: {key}")
        response = s3.get_object(Bucket=bucket, Key=key)
        logger.info(f"response: {response}")
        image = Image.open(response["Body"])
        image_data = list(image.getdata())
        image_no_exif = Image.new(image.mode, image.size)
        image_no_exif.putdata(image_data)
        image_no_exif.save(f"/tmp/{event["detail"]["object"]["key"]}")
        image_no_exif.close()
        dest_bucket = os.environ.get("DEST_BUCKET")
        s3.upload_file(f"/tmp/{event["detail"]["object"]["key"]}", dest_bucket, key)
