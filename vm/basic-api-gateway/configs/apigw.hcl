Kind = "api-gateway"
Name = "api-gateway"
Listeners = [
    {
        name = "listener-one"
        port     = 9001
        protocol = "http"
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
]
