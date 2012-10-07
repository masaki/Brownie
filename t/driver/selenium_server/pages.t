use strict;
use warnings;
use Test::More;
use Test::Fake::HTTPD;
use Test::Exception;
use File::Temp;
use Brownie::Driver::SeleniumServer;

my $driver = Brownie::Driver::SeleniumServer->new;

my $body = <<__HTTPD__;
<html>
  <head><title>test title</title></head>
  <body>Hello Brownie</body>
</html>
__HTTPD__

my $httpd = Test::Fake::HTTPD->new(timeout => 30);
$httpd->run(sub { [ 200, [ 'Content-Type' => 'text/html' ], [ $body ] ] });

subtest 'Pages' => sub {
    $driver->visit($httpd->endpoint);

    subtest 'title' => sub {
        is $driver->title => 'test title';
    };

    subtest 'source' => sub {
        my $data = $driver->source;
        like $data => qr!<html!s;
        like $data => qr!</html>!s;
        like $data => qr!Hello Brownie!;
    };

    subtest 'screenshot' => sub {
        my $path = File::Temp->new(UNLINK => 1, suffix => '.png')->filename;
        ok ! -e $path;

        $driver->screenshot($path);
        ok -e $path && -s _ && -B _;

        unlink $path;
    };
};


done_testing;
