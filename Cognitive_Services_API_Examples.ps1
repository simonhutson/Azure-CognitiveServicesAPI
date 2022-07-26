# Install & Import Microsoft Authentication Library (MSAL) - https://github.com/AzureAD/MSAL.PS
Install-Module MSAL.PS `
    -Scope CurrentUser `
    -Force `
    -AllowClobber
Import-Module MSAL.PS `
    -Force

Get-ChildItem Env:

$tenantId="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
$subscriptionId="bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
$resourceGroupName="<resource_group_name>"
$cognitiveServicesName="<cognitive_services_account_name>"

$servicePrincipalApplicationId="cccccccc-cccc-cccc-cccc-cccccccccccc"
$servicePrincipalSecret="<service_principal_secret>"

# Custom domain endpoint
$cognitiveServicesAccountEndpoint="https://<cognitive_services_account_name>.cognitiveservices.azure.com/"

# Convert Service Principal Secret to secure string - https://docs.microsoft.com/powershell/module/microsoft.powershell.security/convertto-securestring
$servicePrincipalSecretSecureString = ConvertTo-SecureString `
    -String $servicePrincipalSecret `
    -AsPlainText -Force

$servicePrincipalToken=Get-MsalToken `
    -ClientId $servicePrincipalApplicationId `
    -ClientSecret $servicePrincipalSecretSecureString `
    -TenantId $tenantId `
    -Scope "https://cognitiveservices.azure.com/.default" `
    -AzureCloudInstance AzurePublic `
    -ForceRefresh

# https://docs.microsoft.com/azure/cognitive-services/computer-vision/how-to/call-analyze-image
Clear-Host
$url = $cognitiveServicesAccountEndpoint+"vision/v3.1/models" 
$headers = @{
    "Authorization"=$servicePrincipalToken.CreateAuthorizationHeader()
}
$result = $null
$result = Invoke-RestMethod -Uri $url `
    -Method Get `
    -Headers $headers `
    -Verbose
$result | ConvertTo-Json

# https://docs.microsoft.com/azure/cognitive-services/translator/reference/v3-0-reference
Clear-Host
$url = $cognitiveServicesAccountEndpoint+"translator/text/v3.0/translate?api-version=3.0&from=en&to=es"
$headers = @{
    "Authorization"=$servicePrincipalToken.CreateAuthorizationHeader()
    "Content-Type"="application/json"
}
$body = @(
    @{
        "Text"="How much for the cup of coffee?"
    }
    @{
        "Text"="When is the next train to Manchester?"
    }
) | ConvertTo-Json
$result = $null
$result = Invoke-RestMethod -Uri $url `
    -Method Post `
    -Headers $headers `
    -Body $body `
    -Verbose 
$result | ConvertTo-Json

# https://docs.microsoft.com/rest/api/cognitiveservices-textanalytics/3.0/sentiment/sentiment
Clear-Host
$url = $cognitiveServicesAccountEndpoint+"text/analytics/v3.0/sentiment"
$headers = @{
    "Authorization"=$servicePrincipalToken.CreateAuthorizationHeader()
    "Content-Type"="application/json"
}
$body = @{
    "documents"=@(
        @{
            "language"="en"
            "id"="1"
            "text"="Hello world. This is some input text that I love."
        }
        @{
            "language"="en"
            "id"="2"
            "text"="It's incredibly sunny outside! I'm so happy."
        }
        @{
            "language"="en"
            "id"="3"
            "text"="Pike place market is my favorite Seattle attraction."
        }
    )  
} | ConvertTo-Json
$result = $null
$result = Invoke-RestMethod -Uri $url `
    -Method Post `
    -Headers $headers `
    -Body $body `
    -Verbose 
$result | ConvertTo-Json

# https://docs.microsoft.com/rest/api/cognitiveservices-textanalytics/3.0/sentiment/sentiment
Clear-Host
$url = $cognitiveServicesAccountEndpoint+"text/analytics/v3.0/keyPhrases"
$headers = @{
    "Authorization"=$servicePrincipalToken.CreateAuthorizationHeader()
    "Content-Type"="application/json"
}
$body = @{
    "documents"=@(
        @{
            "language"="en"
            "id"="1"
            "text"="Hello world. This is some input text that I love."
        }
        @{
            "language"="fr"
            "id"="2"
            "text"="Bonjour tout le monde."
        }
        @{
            "language"="es"
            "id"="3"
            "text"="La carretera estaba atascada. Había mucho tráfico el día de ayer."
        }
    )  
} | ConvertTo-Json
$result = $null
$result = Invoke-RestMethod -Uri $url `
    -Method Post `
    -Headers $headers `
    -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
    -Verbose 
$result | ConvertTo-Json

# https://docs.microsoft.com/rest/api/computervision/3.1/analyze-image/analyze-image
Clear-Host
$url = $cognitiveServicesAccountEndpoint+"vision/v3.1/analyze?visualFeatures=Categories,Tags,Description,ImageType,Objects,Brands&details=Landmarks&language=en"
$headers = @{
    "Authorization"=$servicePrincipalToken.CreateAuthorizationHeader()
    "Content-Type"="application/json"
}
$body = @{
    "url" = "https://www.antiquesnavigator.com/archive/2012/01/31/260941509464.jpg"
} | ConvertTo-Json
$result = $null
$result = Invoke-RestMethod -Uri $url `
    -Method Post `
    -Headers $headers `
    -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
    -Verbose 
$result | ConvertTo-Json

# https://docs.microsoft.com/rest/api/computervision/3.1/generate-thumbnail/generate-thumbnail
Clear-Host
$url = $cognitiveServicesAccountEndpoint+"vision/v3.1/generateThumbnail?width=500&height=500&smartCropping=True"
$headers = @{
    "Authorization"=$servicePrincipalToken.CreateAuthorizationHeader()
    "Content-Type"="application/json"
}
$body = @{
    "url"="https://mongooseagency.com/files/7215/7372/5255/LMLE_Release_Image_copy.jpg"
} | ConvertTo-Json
$result = $null
$result = Invoke-RestMethod -Uri $url `
    -Method Post `
    -Headers $headers `
    -Body $body `
    -OutFile "$Env:USERPROFILE\desktop\thumbnail.jpg" `
    -Verbose 
