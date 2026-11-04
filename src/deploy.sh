#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PRODCERT_DIR="${SCRIPT_DIR}/prodcert"

if [ ! -f "${SCRIPT_DIR}/.env" ]; then
  echo "Error: Missing ${SCRIPT_DIR}/.env file." >&2
  exit 1
fi

# Load static variables from .env
set -a
source "${SCRIPT_DIR}/.env"
set +a

echo "==> [oauth] Applying OAuth proxy configuration for ${AUTH_SUBDOMAIN}.${BASE_DOMAIN}..."
envsubst < "${SCRIPT_DIR}/oauth.yaml" | kubectl apply -f -

echo "==> [oauth] Verifying secret creation..."
kubectl get secret github-oauth-creds -n "${NAMESPACE}"