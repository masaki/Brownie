use Test::More;
use Test::Flatten;
use Test::Exception;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;
use t::Helper;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd;

describe 'Brownie::Driver::Selenium#visit' => sub {
    it 'should not die when access to exist URL' => sub {
        lives_ok { $driver->visit($httpd->endpoint) };
    };
};

my $path = '/';

describe 'Brownie::Driver::Selenium#current_url' => sub {
    it 'should get URL' => sub {
        $driver->visit($httpd->endpoint);
        is $driver->current_url => $httpd->endpoint.$path; # redirect
    };
};

describe 'Brownie::Driver::Selenium#current_path' => sub {
    it 'should get path of URL' => sub {
        $driver->visit($httpd->endpoint);
        is $driver->current_path => $path;
    };
};

done_testing;
