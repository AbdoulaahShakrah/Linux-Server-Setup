
check_type() {
    if [[ $1 == "A" || $1 == "AAAA" || $1 == "CNAME" || $1 == "MX" || $1 == "NS" || $1 == "PTR" || $1 == "SOA" ]]; then
        return 0
    else
        return 1
    fi
}

#add_register() {
#local line_number=$(( $1 + 1 ))
#sed -i "${}i\\$5 IN  $2  $3" "/var/named/$4.hosts"
#echo "O tipo $2 foi adicionado para o dominio $3 com sucesso!!!!"
#}


add_register() {
    echo "$5 	IN 	$2	$3" >> "/var/named/$4.hosts"
    echo "O subdominio $5 foi adicionado para o domínio $4 com sucesso!!!!"
}

createRegistory(){

read -p "Entre o nome do domínio: " domain_name
read -p "Entre o nome do subdominio: " subdomain
read -p "Entre o IP: " ip_server
read -p "Entre o tipo de registro que queres adicionar: " type

if grep -q "$domain_name" "/etc/named.conf"; then
    lines_num=$(wc -l < "/var/named/$domain_name.hosts")

    while ! check_type "$type"; do
        read -p "Tipo de registro inválido, tente novamente: " type
    done

    add_register "$lines_num" "$type" "$ip_server" "$domain_name" "$subdomain"

else
    echo "O nome de domínio não existe"
fi
systemctl restart named

}
