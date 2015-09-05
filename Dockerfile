FROM mhart/alpine-node:0.12.7

RUN apk-install git

# Note: npm is v2.14.1
RUN npm install -g \
  ember-cli@1.13.8 \
  bower@1.5.2 \
  phantomjs@1.9.18

EXPOSE 4200 35729 49152
WORKDIR /ember-app
ENTRYPOINT ["/usr/bin/ember"]
CMD ["help"]
