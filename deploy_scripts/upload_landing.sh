/usr/bin/expect<<EOD
spawn /usr/bin/sftp $PROD_FTP_USERNAME@$PROD_FTP_DOMAIN
expect "password:"
send "$PROD_FTP_PASSWORD\r"
expect "sftp>"
send "cd testing\r"
expect "sftp>"
send "put $MIDDLEMAN_BUILD_PATH/index.html\r"
expect "sftp>"
send "bye\r"
EOD
