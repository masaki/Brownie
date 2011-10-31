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

describe 'Brownie::Node::Selenium#find_elements' => sub {
    it 'should get elements under specified element' => sub {
        my $parent = elem('p#parent');
        my @children = $parent->find_elements('a');
        is scalar(@children) => 2;
        is $children[0]->text => 'child3';
        is $children[1]->text => 'child4';

        my @anchors = $driver->find_elements('a');
        cmp_ok scalar(@anchors), '>', scalar(@children);
    };
};

undef $driver;
done_testing;
