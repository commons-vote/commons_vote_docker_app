#!/usr/bin/env plackup

use strict;
use warnings;

use Error::Pure qw(err);
use Plack::App::Commons::Vote;
use Plack::App::Commons::Vote::Login;
use Plack::Builder;
use Plack::Middleware::Session;
use Plack::Middleware::Auth::OAuth2;
use Readonly;
use Schema::Commons::Vote;
use Tags::Output::Raw;

our $VERSION = 0.43;

my $debug = $ENV{'DEBUG'} || 0;

if (! exists $ENV{'CLIENT_ID'}) {
	err "Environment variable 'CLIENT_ID' is missing.";
}
if (! exists $ENV{'CLIENT_SECRET'}) {
	err "Environment variable 'CLIENT_SECRET' is missing.";
}

my $dsn = 'dbi:Pg:dbname='.$ENV{'DB_NAME'};
if (defined $ENV{'DB_HOST'}) {
	$dsn .= ';host='.$ENV{'DB_HOST'};
}
my $schema = Schema::Commons::Vote->new->schema->connect(
	$dsn,
	$ENV{'DB_USER'} || '',
	$ENV{'DB_PASS'} || '',
);
my $backend = Backend::DB::Commons::Vote->new(
	'schema' => $schema,
);
my ($css, $tags);
my %tags = (
	'no_simple' => ['script', 'textarea'],
	'preserved' => ['pre', 'script', 'style', 'textarea'],
	'xml' => 1,
);
if ($debug) {
	require CSS::Struct::Output::Indent;
	$css = CSS::Struct::Output::Indent->new;
	require Tags::Output::Indent;
	$tags = Tags::Output::Indent->new(%tags);
} else {
	require CSS::Struct::Output::Raw;
	$css = CSS::Struct::Output::Raw->new;
	require Tags::Output::Raw;
	$tags = Tags::Output::Raw->new(%tags);
}

my $app = Plack::App::Commons::Vote->new(
	'css' => $css,
	'backend' => $backend,
	'lang' => 'ces',
	'schema' => $schema,
	'tags' => $tags,
	'title' => 'Commons Vote',
)->to_app;

builder {
	enable 'Session';
	enable 'Auth::OAuth2',
		'app_login' => Plack::App::Commons::Vote::Login->new(
			'backend' => $backend,
			'css' => $css,
			'tags' => $tags,
			'theme' => 'cwp',
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
