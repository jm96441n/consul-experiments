Kind = "service-intentions"
Name = "nibbler"

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
