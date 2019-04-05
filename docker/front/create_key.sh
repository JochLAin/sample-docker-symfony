openssl genrsa -des3 -out $1.key -passout pass:word 1024
openssl req -new -key $1.key -passin pass:word -out $1.csr -subj "/C=FR/ST=France/L=Lyon/O=JochLAin/CN=symfony.local"

cp $1.key $1.key.org
openssl rsa -in $1.key.org -passin pass:word -out $1.key
rm -f $1.key.org

openssl x509 -req -days 365 -in $1.csr -signkey $1.key -out $1.crt