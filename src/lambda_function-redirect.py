import os, string, random
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["DYNAMODB_TABLE"])

def getLongUrl(shortCode):
    response = table.get_item(
        Key={
            'ShortCode': str(shortCode)
        }
    )
    return response.get('Item', {}).get('LongUrl')

def lambda_handler(event, context):
    shortCode = event['pathParameters']['ShortCode']

    if not shortCode:
        return {
            "statusCode": 400,
            "error": "ShortCode is required"
        }

    longUrl = getLongUrl(shortCode)
    
    if longUrl:
        return {
            "statusCode": 301, 
            "headers": {"Location": longUrl}
        }

    else:
        return {
            "statusCode": 400,
            "error": "ShortCode not in table"
            }
