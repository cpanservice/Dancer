use strict;
use warnings;

use lib 't';
use TestUtils;
use Test::More 'no_plan', import => ['!pass'];

BEGIN {
    use_ok 'Dancer';
    use_ok 'Dancer::Route';
}

{
    ok(get('/' => sub { 'index' }), 'first route set');
    ok(get('/hello/:name' => sub { params->{name} }), 'second route set');
    ok(get('/hello/:foo/bar' => sub { params->{foo} }), 'third route set');
    ok(post('/new/:stuff' => sub { params->{stuff} }), 'post route set');
}

my @tests = (
    {method => 'GET', path => '/', expected => 'index'},
    {method => 'GET', path => '/hello/sukria', expected => 'sukria'},
    {method => 'GET', path => '/hello/joe/bar', expected => 'joe' },
    {method => 'post', path => '/new/wine', expected => 'wine' },

);


foreach my $test (@tests) {
    my $cgi = TestUtils::fake_request($test->{method} => $test->{path});

    Dancer::SharedData->cgi($cgi);
    my $response = Dancer::Renderer::get_action_response();

    ok( defined $response, 
        "route handler found for path `".$test->{path}."'");

    is( $response->{content}, $test->{expected}, 
        "matching param looks good: ".$response->{content});
}
