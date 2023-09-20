Kind = "api-gateway"
Name = "api-gateway"
Listeners = [
  {
    name = "listener-one"
    port     = 9001
    protocol = "http"
    override = {
        JWT = {
            Providers = [
                {
                    Name="local"
                }
            ]
        }
    }
  }
]
