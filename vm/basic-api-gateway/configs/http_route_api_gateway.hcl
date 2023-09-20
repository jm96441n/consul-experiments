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
    filters = {
        JWT = {
            Providers = [
                {
                    Name = "okta",
                    VerifyClaims = {
                        Path = ["aud"],
                        Value = "api.apps.organization.com",
                    }
                },
                {
                    Name = "okta",
                    VerifyClaims = {
                        Path = ["perms", "role"],
                        Value = "admin",
                    }
                }
            ]
        }
    }

    services = [
      {
        name = "bender"
      }
    ]
  }
]
