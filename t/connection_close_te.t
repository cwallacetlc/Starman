use strict;
use Plack::Test;
use Test::More;
use HTTP::Request::Common qw(GET);

$Plack::Test::Impl = "Server";
$ENV{PLACK_SERVER} = 'Starman';

my $app = sub {
    my $env = shift;
    return [ 200, [ 'Content-Type', 'text/plain' ], [ 'content' ] ];
};

test_psgi $app, sub {
    my $cb = shift;

    my $res = $cb->(GET 'http://localhost/', TE => 'deflate,gzip;q=0.3', Connection => 'close, TE');

    is $res->header('Connection'), 'close';
};

done_testing;
