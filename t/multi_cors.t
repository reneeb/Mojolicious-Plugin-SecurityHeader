use Mojo::Base -strict;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;

plugin 'SecurityHeader' => [
    'Strict-Transport-Security' => -1,
    'X-Xss-Protection',
    'Referrer-Policy'        => 'no-referrer',
    'X-Content-Type-Options' => 'nosniff',

    # CORS
    'Access-Control-Allow-Origin',
    'Access-Control-Allow-Methods' => [
        qw/GET POST DELETE PUT PATCH OPTIONS/
    ],
    'Access-Control-Allow-Headers' => [
        qw/Content-Type api_key Authorization/
    ],
];

get '/' => sub {
  my $c = shift;
  $c->render(text => 'Hello Mojo!');
};

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)
  ->header_is( 'Strict-Transport-Security', 'max-age=31536000', 'STS' )
  ->header_is( 'X-Xss-Protection', '1; mode=block', 'XXP' )
  ->header_is( 'X-Content-Type-Options', 'nosniff' )
  ->header_is( 'Referrer-Policy', 'no-referrer', 'RP' )
  ->header_is( 'Access-Control-Allow-Origin', '*', 'ACAO' )
  ->header_is( 'Access-Control-Allow-Methods', 'GET, POST, DELETE, PUT, PATCH, OPTIONS', 'ACAM' )
  ->header_is( 'Access-Control-Allow-Headers', 'Content-Type, api_key, Authorization', 'ACAH' )
;

done_testing();
