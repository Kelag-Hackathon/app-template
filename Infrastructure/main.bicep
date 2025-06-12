targetScope = 'resourceGroup'

param teamName            string
param sharedRgName        string
param containerEnvName    string
param location            string = resourceGroup().location
param registryUsername    string
param surveyImage         string
param reportingImage      string
param containerAppSecrets array = []

resource caEnv 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: containerEnvName
  scope: resourceGroup(sharedRgName)
}

module surveyApp 'modules/application/container-app.bicep' = {
  name: 'deploy-survey-${teamName}'
  scope: resourceGroup()
  params: {
    location:                  location
    containerAppEnvironmentId: caEnv.id
    name:                      'survey-${teamName}'
    additionalTags:            { team: teamName, role: 'survey' }
    costcenter:                ''
    registry:                  {
      server:            'ghcr.io'
      username:          registryUsername
      passwordSecretRef: 'github-token'
    }
    containerImageWithVersion: surveyImage
    targetPort:               80
    cpu:                      '0.5'
    memory:                   '1Gi'
    stickySessions:           'none'
    secrets:                  containerAppSecrets
    environmentVariables:     []
  }
}

module reportingApp 'modules/application/container-app.bicep' = {
  name: 'deploy-report-${teamName}'
  scope: resourceGroup()
  params: {
    location:                  location
    containerAppEnvironmentId: caEnv.id
    name:                      'report-${teamName}'
    additionalTags:            { team: teamName, role: 'report' }
    costcenter:                ''
    registry:                  {
      server:            'ghcr.io'
      username:          registryUsername
      passwordSecretRef: 'github-token'
    }
    containerImageWithVersion: reportingImage
    targetPort:               80
    cpu:                      '0.5'
    memory:                   '1Gi'
    stickySessions:           'none'
    secrets:                  containerAppSecrets
    environmentVariables:     []
  }
}
