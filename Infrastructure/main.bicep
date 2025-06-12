targetScope = 'resourceGroup'

@description('Team name (no spaces), used in RG and app names.')
param teamName                 string

@description('Name of the shared resource group containing your Container Apps Environment.')
param sharedRgName             string

@description('Name of the existing Container Apps Environment in the shared RG.')
param containerEnvName         string

@description('Azure location for the team RG (must match where it was created).')
param location                string = resourceGroup().location

@description('Your GHCR username (e.g. your org or user).')
param registryUsername        string

@description('Full image ref for the Survey app, e.g. ghcr.io/org/survey-app-team:tag')
param surveyImage             string

@description('Full image ref for the Reporting app, e.g. ghcr.io/org/reporting-app-team:tag')
param reportingImage          string

@description('List of secrets (name/value) for the Container Apps')
param containerAppSecrets array = []


// Pull in the existing Managed Environment
resource caEnv 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: containerEnvName
  scope: resourceGroup(sharedRgName)
}

// Deploy the Survey Container App
module surveyApp './shared-bicep-modules/application/container-app.bicep' = {
  name: 'deploy-survey-${teamName}'
  scope: resourceGroup()
  params: {
    location:                        location
    secrets:                         containerAppSecrets
    containerAppEnvironmentId:       caEnv.id
    containerAppEnvironmentFullDomain: caEnv.properties.defaultDomain
    containerAppEnvironmentLoadBalancerIp: caEnv.properties.staticIp
    name:                            'survey-${teamName}'
    domain:                          ''
    environment:                     ''
    additionalTags:                  { team: teamName }
    costcenter:                      ''
    identityId:                      ''
    registry: {
      server:                        'ghcr.io'
      username:                      registryUsername
      passwordSecretRef:             'github-token'
    }
    containerImageWithVersion:      surveyImage
    targetPort:                     80
    cpu:                            '0.5'
    memory:                         '1Gi'
    stickySessions:                 'none'
    secrets:                        []
    environmentVariables:           []
  }
}

// Deploy the Reporting Container App
module reportingApp './shared-bicep-modules/application/container-app.bicep' = {
  name: 'deploy-report-${teamName}'
  scope: resourceGroup()
  params: {
    location:                        location
    secrets:                         containerAppSecrets
    containerAppEnvironmentId:       caEnv.id
    containerAppEnvironmentFullDomain: caEnv.properties.defaultDomain
    containerAppEnvironmentLoadBalancerIp: caEnv.properties.staticIp
    name:                            'report-${teamName}'
    domain:                          ''
    environment:                     ''
    additionalTags:                  { team: teamName }
    costcenter:                      ''
    identityId:                      ''
    registry: {
      server:                        'ghcr.io'
      username:                      registryUsername
      passwordSecretRef:             'github-token'
    }
    containerImageWithVersion:      reportingImage
    targetPort:                     80
    cpu:                            '0.5'
    memory:                         '1Gi'
    stickySessions:                 'none'
    secrets:                        []
    environmentVariables:           []
  }
}
