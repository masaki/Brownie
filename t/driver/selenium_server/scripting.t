use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::Fake::HTTPD;
use Brownie::Driver::SeleniumServer;

my $driver = Brownie::Driver::SeleniumServer->new;

my $body = <<__HTTPD__;
<html><body>ok</body></html>
__HTTPD__

my $httpd = Test::Fake::HTTPD->new(timeout => 30);
$httpd->run(sub { [ 200, [ 'Content-Type' => 'text/html' ], [ $body ] ] });

subtest 'Scripting' => sub {
    $driver->visit($httpd->endpoint);

    subtest 'execute_script' => sub {
        lives_ok { $driver->execute_script("document.title='execute_script'") };
        is $driver->title => 'execute_script';
    };

    subtest 'evaluate_script' => sub {
        my $got;
        lives_ok { $got = $driver->evaluate_script('1 + 2') };
        is $got => 3;
    };
};

done_testing;
