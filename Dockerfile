FROM ruby:2.5

WORKDIR /code
RUN curl -sLo /usr/local/bin/mtail https://github.com/google/mtail/releases/download/v3.0.0-rc29/mtail_v3.0.0-rc29_linux_amd64 \
  && chmod +x /usr/local/bin/mtail
COPY Gemfile .
RUN bundle install
