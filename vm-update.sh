#!/bin/bash

# Parametre
DATE=$(date +"%Y-%m-%d_%H-%M-%S")  # Dátum a čas pre názov logu
LOG_FILE="/home/roberto/ansible-proxmox/logs/update-vm-$DATE.log"  # Nový logový súbor s dátumom a časom
GOTIFY_URL="http://10.20.40.32:80"
APP_TOKEN="AeKqufT-RyQo_HL"  # API token z vašej Gotify aplikácie
TITLE="Ansible VM Update Logs"

# Spustenie Ansible playbooku a zaznamenanie výstupu do logu
/usr/bin/ansible-playbook -i /home/roberto/ansible-proxmox/hosts /home/roberto/ansible-proxmox/update-vm.yaml >> $LOG_FILE 2>&1

# Funkcia na úpravu logov (preformátuje výstup na zrozumiteľnejší formát)
format_log() {
    # Zobrazenie úloh s konkrétnymi stavmi
    while IFS= read -r line; do
        # Ak riadok obsahuje dlhý text (napríklad dlhé sekcie s hviezdičkami), rozdelíme ho na viacero riadkov
        if [ ${#line} -gt 100 ]; then
            # Rozdelíme dlhý riadok na viacero častí (do 100 znakov na riadok)
            echo "$line" | fold -w 100
        else
            echo "$line"
        fi
    done < "$LOG_FILE"
}

# Získanie logu a jeho preformátovanie
CONTENT=$(format_log)

# Odstránenie nových riadkov v správe, aby sa predišlo neplatnému znaku
# Prevod na platný JSON (nahradenie špeciálnych znakov ako nové riadky a úvodzovky)
CONTENT=$(echo "$CONTENT" | jq -Rs .)

# Poslanie logu cez curl do Gotify
curl -X POST "$GOTIFY_URL/message?token=$APP_TOKEN" \
     -H "Content-Type: application/json" \
     -d "{\"title\":\"$TITLE\",\"message\":$CONTENT,\"priority\":5}"
