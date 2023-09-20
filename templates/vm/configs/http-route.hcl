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
    matches = [
        {
            path = {
                match = "prefix"
                value = "/bender"
            }
        }
    ]
    services = [
      {
        name = "bender"
      },
    ]
  },
  {
    matches = [
        {
            path = {
                match = "prefix"
                value = "/zoidberg"
            }
        }
    ]
    services = [
      {
        name = "zoidberg"
      }
    ]
  },
  {
    matches = [
        {
            path = {
                match = "prefix"
                value = "/nibbler"
            }
        }
    ]
    services = [
      {
        name = "nibbler"
      }
    ]
  },
]
