Kind = "service-intentions"
Name = "bender"

Sources = [
    {
        Name = "api-gateway-route"
        Permissions = {
            Action = "allow"
            HTTP = {
                PathPrefix = "/"
            }
        }
    },
    {
        Name = "*"
        Permissions = {
            Action = "deny"

            HTTP = {
                PathPrefix = "/"
            }
        }
    }
]
