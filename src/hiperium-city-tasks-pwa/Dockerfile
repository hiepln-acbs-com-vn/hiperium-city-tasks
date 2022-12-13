##########################################################################
######################### Stage 1 : Build Image ##########################
##########################################################################
FROM node:17.4.0 AS build
RUN apt-get update && apt-get install -y --no-install-recommends
ENV NODE_ENV production
WORKDIR /usr/src/app
COPY package*.json /usr/src/app/
RUN --mount=type=secret,mode=0644,id=npmrc,target=/usr/src/app/.npmrc npm ci --only=production
COPY . /usr/src/app
RUN npm run build

##########################################################################
########################## Stage 2: Docker Image #########################
##########################################################################
FROM node:17.0.4-bullseye-slim
COPY --chown=node:node --from=build /usr/src/app/www /usr/src/app/www
USER node
WORKDIR /usr/src/app
RUN npm install -g http-server
CMD ["http-server", "/usr/src/app/www", "-p", "8100"]
EXPOSE 8100
