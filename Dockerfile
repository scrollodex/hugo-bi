## Build air2hugo and dyngo
FROM golang:1.17-alpine AS gobuild
COPY scrolloserver /scrolloserver
WORKDIR /scrolloserver/cmd/air2hugo
RUN go build
WORKDIR /scrolloserver/cmd/dyngo
RUN go build

## get running our build
FROM node:17-alpine3.14

RUN apk add --no-cache hugo git

# This user is built into the node image
USER 1000

## You have to provide these at build time. There's probably a better way
#  to indicate this, but, 🤷
ENV AIRTABLE_APIKEY "SETME"
ENV AIRTABLE_BASE_ID "SETME"

COPY --chown=1000 . /hugo-bi
COPY bin/docker-entrypoint.sh /usr/local/bin/
COPY --from=gobuild /scrolloserver/cmd/air2hugo/air2hugo /usr/local/bin/
COPY --from=gobuild /scrolloserver/cmd/dyngo/dyngo /usr/local/bin/
COPY --from=gobuild /usr/local/go /usr/local/go
ENV PATH "/usr/local/go/bin:${PATH}"

WORKDIR /hugo-bi

#RUN npm i

# TODO(tlim): Figure out how to vendor all dependencies to speed up
# build.
#RUN rm -rf _vendor
#RUN hugo mod get -u &&  hugo mod vendor -v --log --verboseLog

#CMD ["/bin/sh", "-c", "air2hugo && hugo"]
#CMD ["/bin/sh", "-c", "mkdir -p public && /usr/local/bin/dyngo >> public/buildlog.txt"]
CMD /usr/local/bin/bin/docker-entrypoint.sh
