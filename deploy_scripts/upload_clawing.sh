lftp -e "mirror -R $MIDDLEMAN_BUILD_PATH/clawing /$PROD_FTP_PATH/clawing; bye;" -u $PROD_FTP_USERNAME,$PROD_FTP_PASSWORD $PROD_FTP_DOMAIN
