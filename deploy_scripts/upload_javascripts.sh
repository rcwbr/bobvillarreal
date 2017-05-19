lftp -e "mirror -R $MIDDLEMAN_BUILD_PATH/javascripts /$PROD_FTP_PATH/javascripts; bye;" -u $PROD_FTP_USERNAME,$PROD_FTP_PASSWORD $PROD_FTP_DOMAIN
