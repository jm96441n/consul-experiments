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
    filters = {
        JWT = {
            Providers = [
                {
                    Name="local"
                    VerifyClaims = [
                        {
                            Path = ["role"]
                            Value = "doctor"
                        }
                    ]
                }
            ]
        }
    }
    services = [
      {
        name = "bender"
      },
      {
        name = "nibbler"

    filters = {
        JWT = {
            Providers = [
                {
                    Name="local"
                    VerifyClaims = [
                        {
                            Path = ["role"]
                            Value = "pet"
                        }
                    ]
                }
            ]
        }
    }
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
]

# DONT FORGET TO EXPORT VARS!!
