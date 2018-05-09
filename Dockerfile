FROM ruby:2.4.1-jessie

RUN mkdir -p app
WORKDIR app

RUN mkdir -p logs

COPY /Gemfile ./

RUN bundle update

RUN apt-get update
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update
RUN apt-get install google-chrome-stable -y

COPY features ./features

CMD cucumber features/first_test.feature
