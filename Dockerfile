FROM node

ARG GIT_TOKEN

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://$GIT_TOKEN:x-oauth-basic@github.com/Granitek/react-hot-cold.git
WORKDIR /react-hot-cold

RUN npm install && \
    npm run build