use strict;
use warnings;
use Test::More;
use t::Utils;
use Test::Exception;
use Brownie::Driver::Mechanize;

my $driver = Brownie::Driver::Mechanize->new;

my $httpd = run_httpd_with(<<__HTTPD__);
<html><body>ok</body></html>
__HTTPD__

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
