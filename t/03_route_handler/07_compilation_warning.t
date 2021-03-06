use Test::More import => ['!pass'];

use lib 't';
use TestUtils;
use Dancer;

set warnings => 1;
set show_errors => 1;

get '/warning' => sub {
    my $bar;
	"$bar foo";
};

my @tests = (
    { path => '/warning', 
	  expected => qr/Use of uninitialized value \$bar in concatenation/},
);

plan tests => scalar(@tests);

foreach my $test (@tests) {
	my $req = fake_request(GET => $test->{path});
	Dancer::SharedData->cgi($req);

	my $response = Dancer::Renderer::get_action_response();
	like($response->{content}, 
		$test->{expected}, 
		"response looks good for ".$test->{path});
}
