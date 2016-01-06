FROM node:0.10

# install grunt-cli, bower
RUN npm install -g grunt-cli bower

# Install entrypoint
ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD []
