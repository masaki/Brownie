use Test::More;
use Test::Flatten;
BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;
use t::lib::httpd_helper;
use Test::File;
use HTTP::Response;
use File::Temp;

describe 'Brownie::Driver::Selenium' => sub {
    my $title = 'Test';
    my $body  = '200 OK';
    my $raw   = "<html><head><title>$title</title></head><body>$body</body></html>";
    my $server = start_http_server {
        my $req = shift;
        my $res = HTTP::Response->new(200);
        $res->content($raw);
        return $res;
    };
    my $url = sprintf 'http://127.0.0.1:%d/', $server->port;

    my $driver = Brownie::Driver::Selenium->new;
    $driver->visit($url);

    context '#title' => sub {
        it 'should get <title> text' => sub {
            is $driver->title => $title;
        };
    };

    for my $method (qw(source body html)) {
        context "#${method}" => sub {
            it 'should return raw content' => sub {
                my $data = $driver->$method;
                like $data => qr!<html.+</html>!;
                like $data => qr!$title!;
                like $data => qr!$body!;
            };
        };
    }

    context '#screenshot' => sub {
        it 'should save screenshot file' => sub {
            my $path = File::Temp->new(UNLINK => 1, suffix => '.png')->filename;

            file_not_exists_ok $path;
            $driver->screenshot($path);
            file_exists_ok $path;
            file_not_empty_ok $path;

            unlink $path;
        };
    };
};

done_testing;
