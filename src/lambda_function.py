import string
import random
import awsgi
from flask import Flask, request, jsonify
import boto3

app = Flask(__name__)

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("url-mapping")

URL = "https://sho.rten.me/"
CHARS = string.ascii_letters + string.digits

def randomString(length=8):
    """Generate a random string of fixed length using base-62."""
    return ''.join(random.choice(CHARS) for _ in range(length))

def putItem(shortCode, longUrl):
    response = table.put_item(
        Item={
            'ShortCode': shortCode,
            'LongUrl': longUrl
        }
    )
    return response

def getLongUrl(shortCode):
    response = table.get_item(
        Key={
            'ShortCode': shortCode
        }
    )
    return response.get('Item', {}).get('LongUrl')

@app.route('/shorten', methods=['POST'])
def shortenUrl():
    data = request.json
    longUrl = data.get('LongUrl')
    
    if not longUrl:
        return jsonify({'error': 'Missing longUrl parameter'}), 400
    shortCode = randomString()

    putItem(shortCode, longUrl)
    
    shortUrl = URL + shortCode
    return jsonify({'ShortUrl': shortUrl})

@app.route('/<shortCode>', methods=['GET'])
def redirect(shortCode):
    longUrl = getLongUrl(shortCode)
    
    if longUrl:
        return redirect(longUrl, code=301)
    else:
        return jsonify({'error': 'Short URL not found'}), 404

def lambda_handler(event, context):
    # https://github.com/slank/awsgi/issues/73#issuecomment-1986868661
    event['httpMethod'] = event['requestContext']['http']['method']
    event['path'] = event['requestContext']['http']['path']
    event['queryStringParameters'] = event.get('queryStringParameters', {})
    return awsgi.response(app, event, context) 