FROM zimbra-docker

LABEL maintainer="Wellington Mendes - wellmend0@gmail.com"

ENV TZ=America/Fortaleza

COPY bash .

RUN sh build.sh

CMD sh run.sh