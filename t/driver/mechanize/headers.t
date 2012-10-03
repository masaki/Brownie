use strict;
use warnings;
use Test::More;
use Test::Fake::HTTPD;
use Brownie::Driver::Mechanize;

my $driver = Brownie::Driver::Mechanize->new;

my $body = '<html><body>ok</body></html>';

my $httpd = Test::Fake::HTTPD->new(timeout => 30);
$httpd->run(sub { [ 200, [ 'Content-Type' => 'text/html; charset=utf-8' ], [ $body ] ] });

subtest 'Headers' => sub {
    $driver->visit($httpd->endpoint);

    subtest 'status_code' => sub {
        is $driver->status_code => '200';
    };

    subtest 'response_headers' => sub {
        my $headers = $driver->response_headers;
        isa_ok $headers => 'HTTP::Headers';

        my $ct = $headers->header('Content-Type');
        like $ct => qr!text/html!i;
        like $ct => qr/charset=utf-8/i;
    };
};

done_testing;
