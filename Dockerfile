FROM node:0.12.7

# Note: npm is v2.14.1
RUN npm install -g ember-cli@1.13.7
RUN npm install -g bower@1.5.2
RUN npm install -g phantomjs@1.9.18

EXPOSE 4200 35729 49152
WORKDIR /src
ENTRYPOINT ["/usr/local/bin/ember"]
CMD ["server"]
