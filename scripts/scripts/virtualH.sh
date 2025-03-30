CONF_FILE="/etc/httpd/conf/httpd.conf"

create_virtual_host() {
    DOCUMENT_ROOT="/var/www/html/$1"
    mkdir -p $DOCUMENT_ROOT
    chmod 777 $DOCUMENT_ROOT -R

    VHOST="
<VirtualHost *:80>
    DocumentRoot \"$DOCUMENT_ROOT/\"
    ServerName www.$1
    ServerAlias $1
    <Directory \"$DOCUMENT_ROOT\">
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
        Require method GET POST OPTIONS
    </Directory>
</VirtualHost>
"
    echo "$VHOST" >> $CONF_FILE

    create_html_page "$1"

    systemctl restart httpd
    echo "VirtualHost para $1 configurado com sucesso."
}

create_html_page() {
    DOCUMENT_ROOT="/var/www/html/$1"
    HTML_FILE="$DOCUMENT_ROOT/index.html"

    HTML_CONTENT="
    <h1>Bem-vindo a $1</h1>
    <p>Esta é a página padrão para $1.</p>"

    echo "$HTML_CONTENT" > $HTML_FILE
}



