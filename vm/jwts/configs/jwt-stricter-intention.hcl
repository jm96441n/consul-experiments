Kind = "service-intentions"
Name = "bender"

Sources = [
    {
        Name = "*"
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
                                Value = "human"
                            },
                            {
                                Path = ["role"]
                                Value = "robot"
                            }
                        ]
                    }
                ]
            }
        }
    },
]
