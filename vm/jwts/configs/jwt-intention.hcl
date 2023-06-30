Kind = "service-intentions"
Name = "bender"

Sources = [
    {
        Name = "zoidberg"
        Permissions = {
            Action = "allow"
            HTTP = {
                PathPrefix = "/"
            }
            JWT = {
                Providers = [
                    {
                        Name = "local"
                    }
                ]
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
