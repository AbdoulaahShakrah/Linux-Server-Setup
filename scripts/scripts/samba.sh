insert_to_smb_file() {
    shareName=$1
    workGroup=$2
    groupName=$3
    writable=$4

    cat >> /etc/samba/smb.conf <<EOF
[$shareName]
        workgroup = $workGroup
        path = /srv/$shareName
        valid users = @$groupName
        writable = $writable
        case sensitive = no
        browsable = yes
EOF

    systemctl restart nmb smb
}



deactivate_share() {
    echo -e "\nInsira o nome da partilha que deseja desativar:"
    read -p "Nome da partilha: " shareName

    if grep -q "^\[$shareName\]" /etc/samba/smb.conf; then
        sed -i "/^\[$shareName\]/,+6 s/^/#/" /etc/samba/smb.conf
        systemctl restart smb nmb
        echo -e "Partilha $shareName desativada com sucesso!\n"
    else
        echo -e "Partilha $shareName não encontrada.\n"
    fi
}


change_share() {
    echo -e "\nInsira o nome da partilha que deseja alterar:"
    read -p "Nome da partilha: " shareName

    if grep -q "^\[$shareName\]" /etc/samba/smb.conf; then
        sed -i "/^\[$shareName\]/,+6d" /etc/samba/smb.conf
        rm -rf "/srv/$shareName"

        # Cria um novo compartilhamento com as novas configurações
        create_share
        echo -e "Partilha $shareName alterada com sucesso!\n"
    else
        echo -e "Partilha $shareName não encontrada.\n"
    fi
}

create_share() {
    read -p "Insira o nome da partilha: " shareName
    read -p "Insira o nome do grupo: " groupName
    read -p "Insira o nome do grupo de trabalho: " workGroup
    read -p "Permissão de leitura e escrita (yes, no): " permission

    mkdir -p /srv/$shareName
    chmod -R 0770 /srv/$shareName
    chown -R root:$groupName /srv/$shareName
    chcon -t samba_share_t /srv/$shareName

    if [ "$permission" == "yes" ]; then
        writable="yes"
    else
        writable="no"
    fi

    insert_to_smb_file "$shareName" "$workGroup" "$groupName" "$writable"
}



delete_share() {
    echo -e "\nInsira o nome da partilha que deseja eliminar:"
    read -p "Nome da partilha: " shareName

    if grep -q "^\[$shareName\]" /etc/samba/smb.conf; then
        sed -i "/^\[$shareName\]/,+6d" /etc/samba/smb.conf
        rm -rf "/srv/$shareName"
        systemctl restart smb nmb
        echo -e "Partilha $shareName eliminada com sucesso!\n"
    else
        echo -e "Partilha $shareName não encontrada.\n"
    fi
}


menu() {
    echo -e "\nConfiguração do serviço Samba:\n"
    echo -e "1) Criar partilha\n2) Eliminar partilha\n3) Alterar partilha\n4) Desativar partilha\n"

    read -p "Escolha uma opção: " option

    case $option in
        1) create_share ;;
        2) delete_share ;;
        3) change_share ;;
        4) deactivate_share ;;
        *) echo -e "Seleção inválida!\n" ;;
    esac
}

menu

