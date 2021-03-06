use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

use Mojolicious::Lite;

get '/' => sub {
    my $c = shift;
    $c->render(text => 'Hello Mojo!');
};

my @tests = (
    {
        param  => 'DENY',
        result => 'DENY',
    },
    {
        param  => { 'ALLOW-FROM' => 'https://perl-services.de' },
        result => 'ALLOW-FROM https://perl-services.de',
    },
    {
        param  => 'SAMEORIGIN',
        result => 'SAMEORIGIN',
    },
);

for my $test ( @tests ) {
    plugin SecurityHeader => [
        'X-Frame-Options' => $test->{param},
    ];
    
    my $t = Test::Mojo->new;
    $t->get_ok('/')->status_is(200)->header_is('X-Frame-Options', $test->{result} );
}

done_testing();
