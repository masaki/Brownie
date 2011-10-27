use Test::More;
use Test::Flatten;
use Test::Fake::HTTPD;
use Test::File;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;
use File::Temp;

my $title = 'Test';
my $body  = '200 OK';
my $raw   = "<html><head><title>$title</title></head><body>$body</body></html>";

my $httpd = run_http_server {
    [ 200, ['Content-Type', 'text/html;charset=utf-8'], [$raw] ];
};
my $url = sprintf 'http://127.0.0.1:%d/', $httpd->port;

my $driver = Brownie::Driver::Selenium->new;
$driver->visit($url);

describe 'Brownie::Driver::Selenium#title' => sub {
    it 'should get <title> text' => sub {
        is $driver->title => $title;
    };
};

describe 'Brownie::Driver::Selenium#source' => sub {
    it 'should return raw content' => sub {
        my $data = $driver->source;
        like $data => qr!<html.+</html>!;
        like $data => qr!$title!;
        like $data => qr!$body!;
    };
};

describe 'Brownie::Driver::Selenium#screenshot' => sub {
    it 'should save screenshot file' => sub {
        my $path = File::Temp->new(UNLINK => 1, suffix => '.png')->filename;
        file_not_exists_ok $path;

        $driver->screenshot($path);
        file_exists_ok $path;
        file_not_empty_ok $path;

        unlink $path;
    };
};

done_testing;
