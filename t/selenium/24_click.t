use Test::More;
use Test::Flatten;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;
use Brownie::Node::Selenium;
use t::Helper;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd();
$driver->visit($httpd->endpoint);

sub elem ($) { $driver->find_element($_[0]) }

describe 'Brownie::Node::Selenium#click' => sub {
    it 'should click on link element' => sub {
        elem('#link_id')->click;
        is $driver->current_path => '/id';
    };

    it 'should click on button element' => sub {
        elem('#input_submit')->click;
        is $driver->current_path => '/form';
    };
};

undef $driver;
done_testing;
