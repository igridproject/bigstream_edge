FROM node:lts-alpine

RUN apk add --no-cache make gcc g++ python linux-headers udev

COPY . /app/bigstream-edge

WORKDIR /app/bigstream-edge

RUN npm install

FROM node:lts-alpine

COPY --from=0 /app/bigstream-edge /app/bigstream-edge

RUN npm install -y pm2@latest -g

RUN mkdir -p /var/bigstream/data

EXPOSE 19980 19080 19180

ARG BS_MODE=edge
ENV BS_MODE ${BS_MODE}

# start server
WORKDIR /app/bigstream-edge
CMD pm2-runtime pm2-${BS_MODE}.config.js