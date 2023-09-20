kind = "http-route"
name = "http-route"
parents = [
  {
    sectionName = "listener-two"
    name = "api-gateway"
    kind = "api-gateway"
  },
]

rules = [
    {
        services = [
            {
                name = "zoidberg"
            }
        ]
    }
]
