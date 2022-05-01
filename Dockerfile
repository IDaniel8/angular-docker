#  Stage 1, Compile and Build angular codebase
FROM node:16.14-alpine as builder
WORKDIR /srcapp
COPY . /srcapp
RUN yarn install
RUN yarn run build --build-optimizer --output-path ./dist/appdist

# Stage 2,ready for production with Nginx
FROM nginx:1.17
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /srcapp/dist/appdist /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
CMD echo PORT=[$PORT] && sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'

