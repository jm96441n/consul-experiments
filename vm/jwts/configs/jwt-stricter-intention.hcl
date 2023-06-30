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
