param location                         string = 'westeurope'
param containerAppEnvironmentId        string
param containerAppEnvironmentFullDomain string
param containerAppEnvironmentLoadBalancerIp string
param name                             string
param additionalTags                   object
param costcenter                       string
param registry                         object = {}
param containerImageWithVersion        string
param targetPort                       int
param cpu                              string = '0.25'
param memory                           string = '0.5Gi'
param secrets                          array = []
param environmentVariables             array = []

resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: name
  location: location
  properties: {
    environmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        external: true
        targetPort: targetPort
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
        stickySessions: {
          affinity: 'none'
        }
      }
      secrets: secrets
      registries: [ registry ]
    }
    template: {
      containers: [
        {
          name: name
          image: containerImageWithVersion
          resources: {
            cpu: json(cpu)
            memory: memory
          }
          env: environmentVariables
        }
      ]
    }
  }
  tags: union(additionalTags, { costcenter: costcenter })
}
