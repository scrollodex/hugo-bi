import jwt
import datetime
import requests
import os
import base64

now=int(datetime.datetime.now().timestamp())

# get access token
jwt=jwt.encode({"iss": os.environ['APP_ID'], "iat": now-60, "exp": now+600}, base64.b64decode(os.environ['APP_KEY']), algorithm="RS256").decode()

r=requests.get('https://api.github.com/app/installations', headers={ "Authorization": "Bearer "+jwt, "Accept": "application/vnd.github.v3+json" })
iid=r.json()[0].get('id')

r=requests.post('https://api.github.com/app/installations/%s/access_tokens' % iid, headers={ "Authorization": "Bearer "+jwt, "Accept": "application/vnd.github.v3+json" })
token=r.json().get('token')


# configure git credentials
open(os.path.expanduser('~')+'/.git-credentials', 'w+').write('https://x-access-token:%s@github.com\n' % token)
os.system('git config --global credential.helper store')


api_url = os.environ['API_URL']

# get ID for the first asset of the latest release
r=requests.get("%s/releases/latest" % api_url, headers={ "Authorization": "token %s" % token, "Accept": "application/json" })
asset_id=r.json().get('assets')[0]['id']


# download first asset of the latest release
binary_path="./airtable2publicyaml"
r=requests.get("%s/releases/assets/%d" % (api_url, asset_id), headers={ "Authorization": "token %s" % token, "Accept": "application/octet-stream" })
open(binary_path, "wb").write(r.content)
os.chmod(binary_path, 0o755)


# generate yaml
ret=os.system("%s data/entries.yaml" % binary_path)
if ret != 0:
    exit(1)
