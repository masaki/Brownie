use strict;
use warnings;
use Test::More;
use t::Utils;
use Test::Exception;
use Brownie::Driver::Mechanize;

my $driver = Brownie::Driver::Mechanize->new;

my $httpd = run_httpd_with(<<__HTTPD__);
<html>
  <head><title>test title</title></head>
  <body>Hello Brownie</body>
</html>
__HTTPD__

my $base_url = $httpd->endpoint;

subtest 'Pages' => sub {
    $driver->visit($base_url);

    subtest 'title' => sub {
        is $driver->title => 'test title';
    };

    subtest 'source' => sub {
        my $data = $driver->source;
        like $data => qr!<html>!s;
        like $data => qr!</html>!s;
        like $data => qr!Hello Brownie!;
    };

    subtest 'screenshot' => sub {
        dies_ok { $driver->screenshot };
    };
};


done_testing;
