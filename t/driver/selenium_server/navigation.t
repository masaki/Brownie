use strict;
use warnings;
use Test::More;
use Test::Fake::HTTPD;
use Test::Exception;
use Brownie::Driver::SeleniumServer;

my $driver = Brownie::Driver::SeleniumServer->new;

my $body = <<__HTTPD__;
<html><body>ok</body></html>
__HTTPD__

my $httpd = Test::Fake::HTTPD->new(timeout => 30);
$httpd->run(sub { [ 200, [ 'Content-Type' => 'text/html' ], [ $body ] ] });

my $base_url  = $httpd->endpoint;

subtest 'Navigation' => sub {
    my @path = qw(
        /foo/bar
        /baz/quux
    );

    subtest 'visit' => sub {
        lives_ok { $driver->visit($base_url) };
    };

    subtest 'current_url' => sub {
        for my $path (@path) {
            my $url = $base_url . $path;
            $driver->visit($url);
            is $driver->current_url => $url;
        }
    };

    subtest 'current_path' => sub {
        for my $path (@path) {
            my $url = $base_url . $path;
            $driver->visit($url);
            is $driver->current_path => $path;
        }
    };
};

done_testing;
