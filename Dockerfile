FROM node:latest

ENV DEBIAN_FRONTEND noninteractive
ENV HUBOT_NAME duncan
ENV HUBOT_OWNER Elliot Segler <elliot.segler@gmail.com>
ENV HUBOT_DESCRIPTION A delightfully unhelpful robutt
ENV EXTERNAL_SCRIPTS "hubot-help,hubot-pugme,hubot-zabbix"

RUN useradd hubot -m

RUN npm install -g hubot coffeescript yo generator-hubot

USER hubot

WORKDIR /home/hubot

COPY --chown=hubot:hubot /scripts/* /home/hubot/scripts/
COPY --chown=hubot:hubot external-scripts.json /home/hubot/
COPY --chown=hubot:hubot package.json /home/hubot/

RUN npm install coffee-script --save
RUN yo hubot --owner="${HUBOT_OWNER}" --name="${HUBOT_NAME}" --description="${HUBOT_DESCRIPTION}" --defaults && \
    sed -i /heroku/d ./external-scripts.json && \
    sed -i /redis-brain/d ./external-scripts.json && \
    npm install hubot-scripts && \
    npm install hubot-slack --save

VOLUME ["/home/hubot/scripts"]

CMD bin/hubot -n $HUBOT_NAME --adapter slack
