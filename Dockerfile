FROM zimbra-docker

LABEL maintainer="Wellington Mendes - wellmend0@gmail.com"

ENV TZ=America/Fortaleza

COPY start.sh start.sh
COPY deploy.sh deploy.sh

RUN sh start.sh

CMD sh deploy.sh