FROM node:16

# Create app directory
WORKDIR /usr/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm ci --silent --omit-dev
# If you are building your code for development
# RUN npm install

# Bundle app source
COPY . .

EXPOSE 5005/tcp

CMD [ "node", "server.js" ]
