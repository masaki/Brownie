use Test::More;
use Test::Exception;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;
use t::Helper;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd;
$driver->visit($httpd->endpoint);

describe 'Brownie::Driver::Selenium#find_elements' => sub {
    it 'should accept xpath' => sub {
        is scalar($driver->find_elements('//li')) => 5;
        is scalar($driver->find_elements('//li[@class="even"]')) => 2;
    };

    it 'should accept css selector' => sub {
        is scalar($driver->find_elements('li')) => 5;
        is scalar($driver->find_elements('li.even')) => 2;
    };

    it 'should return () if not exist locator is given' => sub {
        my @elems;
        lives_ok { @elems = $driver->find_elements('span.noexist') };
        is scalar(@elems) => 0;
    };
};

describe 'Brownie::Driver::Selenium#find_element' => sub {
    it 'should accept xpath' => sub {
        is $driver->find_element('//li')->native->get_text => '1';
        is $driver->find_element('//li[@class="even"]')->native->get_text => '2';
    };

    it 'should accept css selector' => sub {
        is $driver->find_element('li')->native->get_text => '1';
        is $driver->find_element('li.even')->native->get_text => '2';
    };

    it 'should return undef if not exist locator is given' => sub {
        my $elem;
        lives_ok { $elem = $driver->find_element('span#noexist') };
        ok !$elem;
    };
};

done_testing;
