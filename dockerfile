from node:14.0.0

COPY app/package.json app/yarn.lock /app/
RUN cd /app \
    && yarn install --pure-lockfile

WORKDIR /app

ADD app/. /app
RUN yarn run start
