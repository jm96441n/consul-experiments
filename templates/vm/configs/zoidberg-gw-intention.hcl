Kind = "service-intentions"
Name = "zoidberg"

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
