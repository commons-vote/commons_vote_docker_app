FROM debian:bullseye

ARG CLIENT_ID
ARG CLIENT_SECRET
ARG DB_NAME
ARG DB_USER
ARG DB_PASS

ENV DEBUG=0

RUN apt-get update 
RUN apt-get install -y make
RUN apt-get install -y cpanminus
RUN apt-get install -y libcapture-tiny-perl
RUN apt-get install -y libdata-formvalidator-perl

# XXX provisional
RUN apt-get install -y libdata-printer-perl
RUN apt-get install -y libdatetime-format-pg-perl
RUN apt-get install -y libdatetime-format-strptime-perl
RUN apt-get install -y libdatetime-perl
RUN apt-get install -y libdbd-pg-perl
RUN apt-get install -y libdbd-sqlite3-perl
RUN apt-get install -y libdbi-perl
RUN apt-get install -y libdbix-class-perl
RUN apt-get install -y libclone-perl
RUN apt-get install -y libdigest-sha-perl
RUN apt-get install -y libfile-share-perl
RUN apt-get install -y libio-captureoutput-perl
RUN apt-get install -y libio-string-perl
RUN apt-get install -y libjson-xs-perl
RUN apt-get install -y liblwp-authen-oauth2-perl
RUN apt-get install -y libmediawiki-api-perl
RUN apt-get install -y libnet-oauth-perl
RUN apt-get install -y libperl6-slurp-perl
RUN apt-get install -y libplack-middleware-session-perl
RUN apt-get install -y libreadonly-perl
RUN apt-get install -y libsub-uplevel-perl
RUN apt-get install -y libtest-exception-perl
RUN apt-get install -y libtest-fatal-perl
RUN apt-get install -y libtest-mockobject-perl
RUN apt-get install -y libtest-nowarnings-perl
RUN apt-get install -y libtest-output-perl
RUN apt-get install -y libtest-warn-perl
RUN apt-get install -y libtest-warnings-perl
RUN apt-get install -y libtext-ansi-util-perl
RUN apt-get install -y libuniversal-can-perl
RUN apt-get install -y libyaml-perl
RUN cpanm CSS::Struct::Output::Indent
RUN cpanm CSS::Struct::Output::Raw
RUN cpanm Error::Pure
RUN cpanm Plack::App::Login
RUN cpanm Plack::Component::Tags::HTML
RUN cpanm Plack::Middleware::Auth::OAuth2
RUN cpanm Tags::HTML::Form
RUN cpanm Tags::Output::Raw
RUN cpanm Tags::Output::Indent
RUN cpanm LWP::Authen::OAuth2::ServiceProvider::Wikimedia
RUN mkdir /perl_modules
COPY perl_modules/ /perl_modules
RUN cpanm perl_modules/Schema-Commons-Vote-0.01.tar.gz
RUN cpanm perl_modules/Schema-Data-Commons-Vote-0.01.tar.gz
RUN cpanm perl_modules/Data-HTML-Textarea-0.01.tar.gz
RUN cpanm perl_modules/Tags-HTML-Image-0.01.tar.gz
RUN cpanm perl_modules/Data-Image-0.01.tar.gz
RUN cpanm perl_modules/Data-Commons-Image-0.01.tar.gz
RUN cpanm perl_modules/Data-Commons-Vote-0.01.tar.gz
RUN cpanm perl_modules/Tags-HTML-Commons-Vote-0.01.tar.gz
RUN cpanm perl_modules/Tags-HTML-Image-Grid-0.01.tar.gz
RUN cpanm perl_modules/Tags-HTML-Login-Register-0.01.tar.gz
RUN cpanm perl_modules/Commons-Vote-Fetcher-0.01.tar.gz
RUN cpanm perl_modules/Backend-DB-0.01.tar.gz
RUN cpanm perl_modules/Backend-DB-Commons-Vote-0.01.tar.gz
RUN cpanm perl_modules/Activity-Commons-Vote-0.01.tar.gz
RUN cpanm perl_modules/Tags-HTML-Container-0.01.tar.gz
RUN cpanm perl_modules/Tags-HTML-Pager-0.04.tar.gz
RUN cpanm perl_modules/Plack-App-Restricted-0.01.tar.gz
RUN cpanm perl_modules/Plack-App-Commons-Vote-0.01.tar.gz

COPY app.psgi /
RUN mkdir /web_root

ENTRYPOINT plackup /app.psgi
