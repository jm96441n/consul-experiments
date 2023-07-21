Kind = "service-intentions"
Name = "bender"

Sources = [
    {
        Name = "api-gateway"
        Permissions = {
            Action = "allow"
            HTTP = {
                PathPrefix="/"
            }
        }
    }
]
