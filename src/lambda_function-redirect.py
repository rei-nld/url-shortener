import os
import string
import random
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["DYNAMODB_TABLE"])

def getLongUrl(shortCode):
    response = table.get_item(
        Key={
            'ShortCode': shortCode
        }
    )
    return response.get('Item', {}).get('LongUrl')

def lambda_handler(event, context):
    shortCode = event.get('ShortCode')
    longUrl = getLongUrl(shortCode)
    
    if longUrl:
        # TODO: Fix redirection
        return {
            "statuscode": 301, 
            "headers": {"Location": longUrl}
        }

    else:
        return {
            "error": "Short URL not found"
            }
