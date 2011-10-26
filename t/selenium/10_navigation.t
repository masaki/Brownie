use Test::More;
use Test::Flatten;
BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;
use t::lib::httpd_helper;
use HTTP::Response;
use URI;

describe 'Brownie::Driver::Selenium' => sub {
    my $driver = Brownie::Driver::Selenium->new;

    my $server = start_http_server {
        my $req = shift;
        my $res = HTTP::Response->new(200);
        $res->content('Stub Response OK');
        return $res;
    };
    my $url = sprintf 'http://127.0.0.1:%d/', $server->port;

    context '#visit' => sub {
        it 'should not die when access to exist URL' => sub {
            ok $driver->visit($url);
        };
    };

    context '#current_url' => sub {
        it 'should get URL' => sub {
            $driver->visit($url);
            is $driver->current_url => $url;
        };
    };

    context '#current_path' => sub {
        it 'should get path of URL' => sub {
            $driver->visit($url);
            is $driver->current_path => URI->new($url)->path;
        };
    };
};

done_testing;
