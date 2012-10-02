use strict;
use warnings;
use Test::More;
use t::Utils;
use Brownie::Driver::Mechanize;

my $driver = Brownie::Driver::Mechanize->new;

my $httpd = run_httpd_with(<<__HTTPD__);
<html><body>ok</body></html>
__HTTPD__

my $base_url = $httpd->endpoint;

subtest 'Headers' => sub {
    $driver->visit($base_url);

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
