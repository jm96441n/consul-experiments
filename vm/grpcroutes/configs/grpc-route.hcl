kind = "grpc-route"
name = "api-gateway-route"
parents = [
  {
    sectionName = "listener-one"
    name = "api-gateway"
    kind = "api-gateway"
  },
]

rules = [
    {
        Matches = [
            {
                service = "bender"
                method = "Speak"
            }
        ]
        Services = {
            name = "bender"
        }
    }
]
