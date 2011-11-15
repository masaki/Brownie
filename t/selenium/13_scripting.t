use Test::More;
use Test::Exception;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;
use t::Helper;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd;

describe 'Brownie::Driver::Selenium#execute_script' => sub {
    it 'should execute script and change elements' => sub {
        $driver->visit($httpd->endpoint);

        is $driver->title => 'test';
        lives_ok { $driver->execute_script("document.title='execute_script'") };
        is $driver->title => 'execute_script';
    };

    it 'should die when specified non-JavaScript' => sub {
        $driver->visit($httpd->endpoint);
        dies_ok { $driver->execute_script(__PACKAGE__) };
        dies_ok { $driver->execute_script('%') };
    };
};

describe 'Brownie::Driver::Selenium#evaluate_script' => sub {
    it 'should execute script and return value' => sub {
        $driver->visit($httpd->endpoint);

        my $result = $driver->evaluate_script('1 + 2');
        is $result => 3;
    };

    it 'should return WebElement when evaluates DOM elements' => sub {
        $driver->visit($httpd->endpoint);

        my $result = $driver->evaluate_script('document.body');
        isa_ok $result => 'Selenium::Remote::WebElement';
    };
};

done_testing;
