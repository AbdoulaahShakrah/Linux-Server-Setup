removeMasterZone(){

read -p "Insire o nome do dominio que quer eliminar: " domain_name

if grep -q "$domain_name" /etc/named.conf; then
    sed -i "/$domain_name/,+3d" /etc/named.conf
    rm -f "/var/named/$domain_name.hosts"
    remove_virtualhost "$domain_name"
    
else
    echo "O domínio $domain_name não foi encontrado no arquivo /etc/named.conf"
fi

systemctl restart named

}


remove_virtualhost() {
    local domain="$1"
    sed -i "/<VirtualHost .*:80>/,/<\/VirtualHost>/ {
        /ServerName $domain/d
        /ServerAlias $domain/d
    }" "/etc/httpd/conf/httpd.conf"
}


