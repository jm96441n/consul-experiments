kind = "http-route"
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
    filters {
        URLRewrite {
            path = "/fortio"
        }
    }

    services = [
      {
        name = "bender"
      }
    ]
    matches = [
        {
            path {
                value = "/default"
                match = "prefix"
            }
        }
    ]
  }
]
