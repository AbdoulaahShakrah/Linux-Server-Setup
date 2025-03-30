addData(){
    case $1 in
        1)
            data="$2"
        ;;
        2)
            data="$3"
        ;;
        *)
            echo "Opção inválida."
            exit 1
        ;;
    esac
    echo "$data"  # Retorna a opção selecionada
    
}

########################Criar partilha########################

createSharing(){
    echo -e "\nCriar uma nova pasta!"
    read -p "Introduza o nome da pasta: " option
    
    mkdir -p /partilhasNFS
    
    ###########Verifica se a pasta existe########
    
    if [ -d "/partilhasNFS/$option" ]; then
        echo -e "A pasta já existe!\n"
    else
        mkdir /partilhasNFS/$option
        chmod 777 /partilhasNFS/$option
        echo -e "Criou com sucesso a pasta /partilhasNFS/$option!\n"
        
        echo -e "Opções de acesso:\n1) ro\n2) rw"
        read -p "Indica a opção de acesso: " access
        access=$(addData "$access" "ro" "rw")
        
        echo -e "\nOpções de visualização:\n1) hide\n2) nohide"
        read -p "Indica a opção de visualização: " visual
        visual=$(addData "$visual" "hide" "nohide")
        
        echo -e "\nOpções de sincronização:\n1) sync\n2) async"
        read -p "Indica a opção de sincronização: " sync
        sync=$(addData "$sync" "sync" "async")
        
        echo -e "/partilhasNFS/$option *($access,$visual,$sync)" >> /etc/exports
        systemctl restart nfs
        echo "Criou com sucesso a partilha da pasta /partilhasNFS/$option!"
    fi
}

########################Eliminar partilha########################
deleteSharing(){
    echo -e "\nIndique o nome da pasta que deseja eliminar a partilha!"
    read -p "Introduza o nome da pasta: " file
    
    ##Procura pela correspondência exato do nome introduzido##
    if grep -qw "$file" /etc/exports; then
        sed -i "\~\b$file\b~d" /etc/exports
        sed -i '/^$/d' /etc/exports
        systemctl restart nfs
        echo -e "A partilha da pasta $file foi apagada com sucesso!\n"
    else
        echo -e "Não foi encontrado nenhuma partilha para a pasta com o nome $file.\n"
    fi
}

########################Alterar partilha########################
changeSharing(){
    echo -e "\nIndique o nome da pasta que deseja alterar a partilha!"
    read -p "Introduza o nome da pasta: " file
    
    ##Procura pela correspondência exato do nome introduzido##
    if grep -qw "$file" /etc/exports; then
        echo -e "Opções de acesso:\n1) ro\n2) rw"
        read -p "Indica a opção de acesso: " access
        access=$(addData "$access" "ro" "rw")
        
        echo -e "\nOpções de visualização:\n1) hide\n2) nohide"
        read -p "Indica a opção de visualização: " visual
        visual=$(addData "$visual" "hide" "nohide")
        
        echo -e "\nOpções de sincronização:\n1) sync\n2) async"
        read -p "Indica a opção de sincronização: " sync
        sync=$(addData "$sync" "sync" "async")
        
        sed -i "\~\b$file\b~d" /etc/exports
        sed -i '/^$/d' /etc/exports
        echo -e "/partilhasNFS/$file *($access,$visual,$sync)" >> /etc/exports
        systemctl restart nfs
        echo -e "A partilha da pasta $file foi alterada com sucesso!\n"
    else
        echo -e "Não foi encontrado nenhuma partilha para a pasta com o nome $file.\n"
    fi
    
}

########################Desativar partilha########################
deactiveSharing(){
    echo -e "\nIndique o nome da pasta que deseja desativar a partilha!"
    read -p "Introduza o nome da pasta: " file
    
    ##Procura pela correspondência exato do nome introduzido##
    if grep -qw "$file" /etc/exports; then
        sed -i "/\<$file\>/ s/^/#/" /etc/exports
        systemctl restart nfs
        echo -e "A partilha da pasta $file foi apagada com sucesso!\n"
    else
        echo -e "Não foi encontrado nenhuma partilha para a pasta com o nome $file.\n"
    fi
}


createNFS(){
    echo -e "\nConfiguração do serviço NFS:\n"
    echo -e "1) Criar partilha\n2) Eliminar partilha\n3) Alterar partilha\n4) Desativar partilha\n"
    
    read -p "Escolha uma opção: " option
    
    case $option in
        1)
            createSharing
        ;;
        
        2)
            deleteSharing
        ;;
        3)
            changeSharing
        ;;
        
        4)
            deactiveSharing
        ;;
        
        *)
            echo -e "Seleção invalida!\n"
        ;;
        
    esac
    
}
