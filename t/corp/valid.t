use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

use Mojolicious::Lite;

get '/' => sub {
    my $c = shift;
    $c->render(text => 'Hello Mojo!');
};

for my $value ( qw(same-origin same-site cross-origin) ) {
    plugin SecurityHeader => [
        'Cross-Origin-Resource-Policy' => $value,
    ];

    my $t = Test::Mojo->new;
    $t->get_ok('/')->status_is(200)->header_is('Cross-Origin-Resource-Policy', $value );
}

done_testing();
