##########################################################################
######################### Stage 1 : Build Image ##########################
##########################################################################
FROM node:17.4.0 AS builder
RUN apt-get update && apt-get install -y --no-install-recommends && npm install -g @angular/cli@14.2.7
WORKDIR /usr/src/app
COPY package*.json /usr/src/app/
RUN npm ci
COPY . /usr/src/app
RUN npm run build

##########################################################################
########################## Stage 2: Docker Image #########################
##########################################################################
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /usr/src/app/www .
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
