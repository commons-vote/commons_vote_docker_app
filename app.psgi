#!/usr/bin/env plackup

use strict;
use warnings;

use Error::Pure qw(err);
use Plack::App::OAuth2::Info;
use Plack::App::Login;
use Plack::Builder;
use Plack::Middleware::Session;
use Plack::Middleware::Auth::OAuth2;
use Readonly;
use Tags::Output::Raw;

our $VERSION = 0.23;

if (! exists $ENV{'CLIENT_ID'}) {
	err "Environment variable 'CLIENT_ID' is missing.";
}
if (! exists $ENV{'CLIENT_SECRET'}) {
	err "Environment variable 'CLIENT_SECRET' is missing.";
}

my $app = Plack::App::OAuth2::Info->new;

builder {
	enable 'Session';
	enable 'Auth::OAuth2',
		'app_login' => Plack::App::Login->new(
			'tags' => Tags::Output::Raw->new,
		),
		'app_login_url' => sub {
			my ($app_login, $url) = @_;
			$app_login->login_link($url);
			return;
		},
		'client_id' => $ENV{'CLIENT_ID'},
		'client_secret' => $ENV{'CLIENT_SECRET'},
		'redirect_path' => 'oauth2_code',
		'service_provider' => 'Wikimedia',
	;
	$app;
};
