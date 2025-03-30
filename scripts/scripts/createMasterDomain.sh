#!/bin/bash
source virtualH.sh

master_zone_content(){
    echo "zone \"$1\" IN {
    type master;
    file \"/var/named/$1.hosts\";
    };"
}

create_domain_file(){
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
        IN A $2
EOF

    echo "Ficheiro do dominio $1 foi criado em /var/named"
}

createMasterZone(){
read -p "Escreve o nome de dominio: " domain_name
read -p "Escreve o ip do servidor: " ip_server

if grep -q "$domain_name" "/etc/named.conf"; then
    echo "domain name exist"
else
    content=$(master_zone_content "$domain_name")
    echo "O domínio $domain_name foi adicionado ao arquivo /etc/named.conf"
    echo "$content" >> "/etc/named.conf"
    create_domain_file "$domain_name" "$ip_server"
    create_virtual_host "$domain_name"
    systemctl restart named
    systemctl restart httpd
fi
}
