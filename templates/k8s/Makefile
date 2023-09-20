.PHONY: start
start:
	./start

.PHONY: reload
reload:
	./reload


.PHONY: exec-nibbler
exec-nibbler:
	kubectl exec -i -t $(kubectl get pods --selector=app=nibbler -o jsonpath='{.items[*].metadata.name}') -c nibble -- /bin/sh

.PHONY: exec-zoidberg
exec-zoidberg:
	kubectl exec -i -t $(kubectl get pods --selector=app=zoidberg -o jsonpath='{.items[*].metadata.name}') -c zoidberg -- /bin/sh
