#!/bin/bash

# Parametre
GOTIFY_URL="http://10.20.40.32:80"
APP_TOKEN="AeKqufT-RyQo_HL"  # API token z vašej Gotify aplikácie
TITLE="Ansible Update Logs"
CONTENT=$(cat /home/roberto/ansible-proxmox/logs/update-proxmox.log)

# Poslanie logu cez curl do Gotify
curl -X POST "$GOTIFY_URL/message?token=$APP_TOKEN" \
     -H "Content-Type: application/json" \
     -d "{\"title\":\"$TITLE\",\"message\":\"$CONTENT\",\"priority\":5}"
