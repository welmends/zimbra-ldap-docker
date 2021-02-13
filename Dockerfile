FROM zimbra-docker

LABEL maintainer="Wellington Mendes - wellmend0@gmail.com"

ENV TZ=America/Fortaleza

COPY deploy.sh deploy.sh
RUN sh deploy.sh

COPY run.sh run.sh
CMD sh run.sh