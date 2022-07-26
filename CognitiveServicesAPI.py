
#%% 
import json
import sys
import logging
import msal
import requests
from msal import ConfidentialClientApplication


#%%
tenantId="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
subscriptionId="bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
resourceGroupName="<resource_group_name>"
cognitiveServicesName="<cognitive_services_account_name>"

servicePrincipalApplicationId="cccccccc-cccc-cccc-cccc-cccccccccccc"
servicePrincipalSecret="<service_principal_secret>"

#%%
cognitiveServicesAccountEndpoint="https://<cognitive_services_account_name>.cognitiveservices.azure.com/"

#%%
config = {
    "authority": "https://login.microsoftonline.com/" + tenantId,
    "scopes": ["https://cognitiveservices.azure.com/.default"],
    "client_id": servicePrincipalApplicationId,
    "client_secret": servicePrincipalSecret
}

#%% 
# https://docs.microsoft.com/azure/active-directory/develop/scenario-daemon-acquire-token?tabs=python#acquiretokenforclient-api
app = ConfidentialClientApplication(
    config["client_id"],
    client_credential=config["client_secret"],
    authority=config["authority"])
 
result = app.acquire_token_for_client(config["scopes"])

#%%
# https://docs.microsoft.com/azure/cognitive-services/computer-vision/how-to/call-analyze-image
endpoint = cognitiveServicesAccountEndpoint + 'vision/v3.1/models'
http_headers = {'Authorization': 'Bearer ' + result['access_token'],
                'Accept': 'application/json',
                'Content-Type': 'application/json'}
response = requests.get(endpoint, headers=http_headers, stream=False)
print(json.dumps(response.json(), indent=4))

#%%
# https://docs.microsoft.com/azure/cognitive-services/translator/reference/v3-0-reference
endpoint = cognitiveServicesAccountEndpoint + 'translator/text/v3.0/translate?api-version=3.0&from=en&to=es'
http_headers = {'Authorization': 'Bearer ' + result['access_token'],
                'Accept': 'application/json',
                'Content-Type': 'application/json'}
body = json.dumps(
        [
            {'Text': 'How much for the cup of coffee?'},
            {'Text': 'When is the next train to Manchester?'}
        ]
    )
response = requests.post(url=endpoint, data=body, headers=http_headers, stream=False)
print(json.dumps(response.json(), indent=4))


#%%
# https://docs.microsoft.com/rest/api/cognitiveservices-textanalytics/3.0/sentiment/sentiment
endpoint = cognitiveServicesAccountEndpoint + 'text/analytics/v3.0/sentiment'
http_headers = {'Authorization': 'Bearer ' + result['access_token'],
                'Accept': 'application/json',
                'Content-Type': 'application/json'}
body = json.dumps(
        {'documents':
            [
                {
                    'Text': 'Hello world. This is some input text that I love.',
                    'language': 'en',
                    'id': '1'
                },
                {
                    'Text': 'It\'s incredibly sunny outside! I\'m so happy.',
                    'language': 'en',
                    'id': '2'
                },
                {
                    'Text': 'Pike place market is my favorite Seattle attraction.',
                    'language': 'en',
                    'id': '3'
                }
            ]
        }
    )
response = requests.post(url=endpoint, data=body, headers=http_headers, stream=False)
print(json.dumps(response.json(), indent=4))


#%%
# https://docs.microsoft.com/rest/api/cognitiveservices-textanalytics/3.0/key-phrases/key-phrases
endpoint = cognitiveServicesAccountEndpoint + 'text/analytics/v3.0/keyPhrases'
http_headers = {'Authorization': 'Bearer ' + result['access_token'],
                'Accept': 'application/json',
                'Content-Type': 'application/json'}
body = json.dumps(
        {'documents':
            [
                {
                    'Text': 'Hello world. This is some input text that I love.',
                    'language': 'en',
                    'id': '1'
                },
                {
                    'Text': 'Bonjour tout le monde.',
                    'language': 'fr',
                    'id': '2'
                },
                {
                    'Text': 'La carretera estaba atascada. Había mucho tráfico el día de ayer.',
                    'language': 'es',
                    'id': '3'
                }
            ]
        }
    )
response = requests.post(url=endpoint, data=body, headers=http_headers, stream=False)
print(json.dumps(response.json(), indent=4))


# %%
# https://docs.microsoft.com/rest/api/computervision/3.1/analyze-image/analyze-image
endpoint = cognitiveServicesAccountEndpoint + 'vision/v3.1/analyze?visualFeatures=Categories,Tags,Description,ImageType,Objects,Brands&details=Landmarks&language=en'
http_headers = {'Authorization': 'Bearer ' + result['access_token'],
                'Accept': 'application/json',
                'Content-Type': 'application/json'}
body = json.dumps(
        {
            'url': 'https://www.antiquesnavigator.com/archive/2012/01/31/260941509464.jpg'
        }
    )
response = requests.post(url=endpoint, data=body, headers=http_headers, stream=False)
print(json.dumps(response.json(), indent=4))
