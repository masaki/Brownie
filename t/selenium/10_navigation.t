use Test::More;
use Test::Flatten;
use Test::Fake::HTTPD;
use Test::Exception;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;

my $driver = Brownie::Driver::Selenium->new;

my $httpd = run_http_server {
    return [ 200, ['Content-Type', 'text/plain;charset=utf-8'], ['Hello World'] ];
};
my $url = sprintf 'http://127.0.0.1:%d/', $httpd->port;

describe 'Brownie::Driver::Selenium#visit' => sub {
    it 'should not die when access to exist URL' => sub {
        lives_ok { $driver->visit($url) };
    };
};

describe 'Brownie::Driver::Selenium#current_url' => sub {
    it 'should get URL' => sub {
        $driver->visit($url);
        is $driver->current_url => $url;
    };
};

describe 'Brownie::Driver::Selenium#current_path' => sub {
    it 'should get path of URL' => sub {
        $driver->visit($url);
        is $driver->current_path => URI->new($url)->path;
    };
};

done_testing;
