FROM debian:bullseye

ARG CLIENT_ID
ARG CLIENT_SECRET

ENV DEBUG=0

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
RUN apt-get install -y liblwp-authen-oauth2-perl
RUN cpanm Error::Pure
RUN cpanm Plack::App::Login
RUN cpanm Plack::App::Data::Printer
RUN cpanm Plack::Component::Tags::HTML
RUN cpanm Tags::Output::Raw
RUN cpanm LWP::Authen::OAuth2::ServiceProvider::Wikimedia
RUN mkdir /perl_modules
COPY perl_modules/ /perl_modules
RUN cpanm perl_modules/Tags-HTML-OAuth2-Info-0.01.tar.gz
RUN cpanm perl_modules/Plack-Middleware-Auth-OAuth2-0.01.tar.gz
RUN cpanm perl_modules/Plack-App-OAuth2-Info-0.01.tar.gz

COPY app.psgi /
RUN mkdir /web_root

ENTRYPOINT plackup /app.psgi
