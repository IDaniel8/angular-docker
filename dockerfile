#  Stage 1, Compile and Build angular codebase
FROM node:16.14-alpine as builder
WORKDIR /srcapp
COPY . /srcapp
RUN yarn install
RUN yarn run build --prod --build-optimizer --output-path ./dist/appdist

# Stage 2,ready for production with Nginx
FROM nginx:1.15
RUN rm -rf /usr/share/nginx/html/*
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /srcapp/dist/appdist /usr/share/nginx/html
ENTRYPOINT ["nginx", "-g", "daemon off;"]
