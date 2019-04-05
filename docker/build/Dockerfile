FROM node

COPY ./docker/build/entrypoint.sh /entrypoint.sh

WORKDIR /home/docker

ENTRYPOINT ["/entrypoint.sh"]

CMD ["npm", "run", "dev"]
