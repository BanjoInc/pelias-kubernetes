helm delete pelias --purge

helm install . \
    --name=pelias \
    --namespace=platform \
    -f values.yaml \
    -f values-banjo.yaml --dry-run --debug

helm install . \
    --name=pelias \
    --namespace=platform \
    -f values.yaml \
    -f values-banjo.yaml

helm upgrade pelias . \
    --namespace=platform \
    -f values.yaml \
    -f values-banjo.yaml --dry-run --debug

helm upgrade pelias . \
    --namespace=platform \
    -f values.yaml \
    -f values-banjo.yaml
