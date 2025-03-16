# Pre-requisties
- Shared cluster is created and the context is configured
- Listing of namespaces in `./setup/namespaces.txt`

# Setup
```bash
cd setup;
# Show list of target namespaces
./run.sh print
# Create namespace and mysql deployments
./run.sh apply
```

# Solution (Manifest)
```bash
cd solution;
kubectl apply -n <namespace> -f wordpress-manifest.yaml
```

# Solution (Helm Chart)
```bash
cd solution;
helm install -n <namespace> -f wordpress-values.yaml wordpress ./wordpress-chart/
```

# Teardown
```bash
# delete namespace
./run.sh delete
```
