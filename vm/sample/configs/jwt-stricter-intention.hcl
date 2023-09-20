Kind = "service-intentions"
Name = "bender"

            JWT = {
                Providers = [
                    {
                        Name = "local"
                    }
                ]
            }
Sources = [
    {
        Name = "*"
        Permissions = {
            Action = "allow"
            HTTP = {
                PathPrefix = "/bender"
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
]
