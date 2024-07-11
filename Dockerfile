FROM ruby:3.1.6-alpine3.20

RUN apk update && apk add make gcc g++ libc-dev openssl-dev && gem install jekyll bundler && adduser -D jekyll

WORKDIR /home/jekyll

COPY --chown=jekyll:jekyll ./entrypoint.sh .

USER jekyll::jekyll

EXPOSE 4000

ENTRYPOINT ["/home/jekyll/entrypoint.sh"]
