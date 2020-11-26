FROM alpine:latest

ENV NODE_ENV production
WORKDIR /thelounge

# Expose HTTP.
ENV PORT 9000
EXPOSE ${PORT}

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["yarn", "start"]

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Install thelounge.
#ARG THELOUNGE_VERSION=4.2.0
#RUN yarn --non-interactive --frozen-lockfile global add thelounge@${THELOUNGE_VERSION} && \
#    yarn --non-interactive cache clean

# Install thelounge - socketio branch
RUN apk --update --no-cache add git yarn nodejs && \
  git clone https://github.com/thelounge/thelounge.git /thelounge && \
  cd /thelounge && \
  git checkout remotes/origin/socketio && \
  yarn install --production=false && \
  NODE_ENV=production yarn build && \
  sed -i 's/The Lounge/Open Chat on DNBRADIO (IRC) - dnbradio.com/g' /thelounge/client/index.html.tpl 