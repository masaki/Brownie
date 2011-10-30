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

describe 'Brownie::Node::Selenium#attr' => sub {
    my $elem = $driver->find_element('h1');

    it 'should access to any attribute' => sub {
        is $elem->attr('id') => 'current_path';
    };
};

describe 'Brownie::Node::Selenium#value' => sub {
    my $elem = $driver->find_element('#input_submit');

    it 'should access to value attribute' => sub {
        is $elem->value => 'Input Submit Value';
    };
};

describe 'Brownie::Node::Selenium#text' => sub {
    my $elem = $driver->find_element('h1');

    it 'should access to child text node' => sub {
        is $elem->text => '/';
    };
};

describe 'Brownie::Node::Selenium#tag_name' => sub {
    my $elem = $driver->find_element('h1');

    it 'should return tag name' => sub {
        is $elem->tag_name => 'h1';
    };
};

done_testing;
