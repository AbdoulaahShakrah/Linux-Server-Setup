removeReverseZone(){
    
    read -p "Insire o ip do dominio que quer eliminar: " ip
    
    new_ip=$(reverse_string "$ip")    

    if grep -q "$new_ip" /etc/named.conf; then
        sed -i "/$new_ip/,+3d" /etc/named.conf
        echo $new_ip
        rm "/var/named/$new_ip.in-addr.arpa.hosts"
    else
        echo "O ip $ip não foi encontrado no arquivo /etc/named.conf"
    fi
    
    systemctl restart named
    
}

reverse_string(){
    firstPart=$(echo $1 | cut -d '.' -f 1)
    secondPart=$(echo $1 | cut -d '.' -f 2)
    thirdPart=$(echo $1 | cut -d '.' -f 3)
    lastPart=$(echo $1 | cut -d '.' -f 4)
    new_ip="$thirdPart.$secondPart.$firstPart"
    echo $new_ip
}





