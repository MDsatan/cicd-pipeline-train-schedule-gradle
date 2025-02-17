#dockerfile
# use a node base image
FROM node:7-onbuild

# set maintainer
LABEL maintainer "sergey_zelentsov@epam.com"

# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:3000 || exit 1

# app content
COPY . /app
WORKDIR /app
RUN npm install

# tell docker what port to expose
EXPOSE 3000

#RUN
CMD ["npm", "start"]