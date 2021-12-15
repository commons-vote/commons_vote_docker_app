FROM debian:buster

ARG CLIENT_ID
ARG CLIENT_SECRET

RUN apt-get update 
RUN apt-get install -y make
RUN apt-get install -y cpanminus
RUN apt-get install -y libdatetime-perl
RUN apt-get install -y libdigest-sha-perl
RUN apt-get install -y libplack-middleware-session-perl
RUN apt-get install -y libclone-perl
RUN apt-get install -y libnet-oauth-perl
RUN apt-get install -y libyaml-perl
RUN apt-get install -y libjson-xs-perl
RUN apt-get install -y libdata-printer-perl
RUN apt-get install -y libreadonly-perl
RUN apt-get install -y libjson-perl
RUN apt-get install -y libtest-nowarnings-perl
RUN apt-get install -y libcapture-tiny-perl
RUN cpanm Error::Pure
RUN cpanm LWP::Authen::OAuth2
RUN cpanm Plack::App::Login
RUN cpanm Tags::Output::Raw
RUN mkdir /perl_modules
COPY perl_modules/ /perl_modules
RUN cpanm perl_modules/Plack-Component-Tags-HTML-0.01.tar.gz
RUN cpanm perl_modules/Plack-Middleware-Auth-OAuth2-0.01.tar.gz
RUN cpanm perl_modules/Plack-App-OAuth2-Info-0.01.tar.gz
RUN cpanm --force perl_modules/LWP-Authen-OAuth2-ServiceProvider-MediaWiki-0.01.tar.gz

COPY app.psgi /
RUN mkdir /web_root

ENTRYPOINT plackup /app.psgi
