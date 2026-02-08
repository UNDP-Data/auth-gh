#!/bin/bash

# 1. Load variables from .env
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo ".env file not found!"
    exit 1
fi


# 2. Use envsubst to inject variables into the manifest
# 3. Pipe the result directly to kubectl
envsubst < oauth.yaml | kubectl apply -f -

#echo "Deployment complete. Checking secret..."
kubectl get secret github-oauth-creds -n auth

# delete 
#kubectl delete -f 01-auth.yaml