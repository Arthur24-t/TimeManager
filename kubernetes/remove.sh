#!/bin/bash

# Delete the resources for the Frontend service
kubectl delete -f web-service.yaml
kubectl delete -f web-deployment.yaml

# Delete the resources for the API service
kubectl delete -f api-service.yaml
kubectl delete -f api-deployment.yaml

# Delete the resources for the PostgreSQL database
kubectl delete -f postgres-service.yaml
kubectl delete -f postgres-deployment.yaml
kubectl delete -f postgres-pvc.yaml
kubectl delete -f postgres-pv.yaml

echo "Removal is complete!"
