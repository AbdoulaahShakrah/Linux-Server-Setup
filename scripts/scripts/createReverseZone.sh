createReverseZone(){
    local file="$3.$2.$1.in-addr.arpa"
    create_reverse_file "$file" "$4" "$5"

    echo "zone \"$file\" IN {
    type master;
    file \"/var/named/$file.hosts\";
    };" >> "/etc/named.conf"
}

add_record(){
    local s="$3.$2.$1.in-addr.arpa"
    echo "$4      IN PTR $5." >> "/var/named/$s.hosts"
}

create_reverse_file(){
    cat > "/var/named/$1.hosts" <<EOF
\$ttl 38400
@ IN SOA dns.estig.pt. mail.as.com. (
        1165190726 ;serial
        10800 ;refresh
        3600 ; retry
        604800 ; expire
        38400 ; minimum
   )
        IN NS dns.estig.pt.
$2      IN PTR $3.
EOF
}



string_reverse(){
    firstPart=$(echo $1 | cut -d '.' -f 1)
    secondPart=$(echo $1 | cut -d '.' -f 2)
    thirdPart=$(echo $1 | cut -d '.' -f 3)
    lastPart=$(echo $1 | cut -d '.' -f 4)

    if [ -f "/var/named/$thirdPart.$secondPart.$firstPart.in-addr.arpa.hosts" ]; then
        add_record "$firstPart" "$secondPart" "$thirdPart" "$lastPart" "$2"
        echo "no if"
    else
        createReverseZone "$firstPart" "$secondPart" "$thirdPart" "$lastPart" "$2"
        echo "Zona reverse criada para $2 com IP $1"
    fi
}

create_reverse_zone(){
    read -p "Entre o nome do domínio: " domain_name
    read -p "Entre o IP do domínio: " ip
    string_reverse "$ip" "$domain_name"
    systemctl restart named
}

