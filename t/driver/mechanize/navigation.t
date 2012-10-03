use strict;
use warnings;
use Test::More;
use Test::Fake::HTTPD;
use Test::Exception;
use Brownie::Driver::Mechanize;

my $driver = Brownie::Driver::Mechanize->new;

my $body = <<__HTTPD__;
<html><body>ok</body></html>
__HTTPD__

my $httpd = Test::Fake::HTTPD->new(timeout => 30);
$httpd->run(sub { [ 200, [ 'Content-Type' => 'text/html' ], [ $body ] ] });

my $base_url  = $httpd->endpoint;
my $other_url = $base_url->clone;
$other_url->path('/foo/bar');

subtest 'Navigation' => sub {
    subtest 'visit' => sub {
        lives_ok { $driver->visit($base_url) };
    };

    subtest 'current_url' => sub {
        for my $url ($base_url, $other_url) {
            $driver->visit($url);
            is $driver->current_url => $url;
        }
    };

    subtest 'current_path' => sub {
        for my $url ($base_url, $other_url) {
            $driver->visit($url);
            is $driver->current_path => $url->path;
        }
    };
};

done_testing;
