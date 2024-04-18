FROM node:20 AS build

WORKDIR /opt/node_app

COPY . .

#COPY package.json yarn.lock ./
#RUN yarn --ignore-optional --network-timeout 600000
RUN yarn --network-timeout 600000

ARG NODE_ENV=production

RUN npx update-browserslist-db@latest
RUN yarn build:app:docker

FROM nginx:1.25.5-alpine3.19

COPY --from=build /opt/node_app/excalidraw-app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
