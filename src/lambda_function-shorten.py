import os, string, random, json
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["DYNAMODB_TABLE"])

URL = "https://sho.rten.me/"
CHARS = string.ascii_letters + string.digits

def randomString(length=8):
    return ''.join(random.choice(CHARS) for _ in range(length))

def putItem(shortCode, longUrl):
    response = table.put_item(
        Item={
            "ShortCode": shortCode,
            "LongUrl": longUrl
        }
    )
    return response

def lambda_handler(event, context):
    body = json.loads(event.get('body'))
    longUrl = body.get('LongUrl')
    
    if not longUrl:
        return {
            'error': 'Missing longUrl parameter'
            }
    
    shortCode = randomString()

    putItem(shortCode, longUrl)
    
    shortUrl = URL + shortCode
    return {
        "ShortUrl": shortUrl
        }