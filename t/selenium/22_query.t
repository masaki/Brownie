use Test::More;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;
use Brownie::Node::Selenium;
use t::Helper;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd;
$driver->visit($httpd->endpoint);

sub elem ($) { return $driver->find_element($_[0]) }

describe 'Brownie::Node::Selenium#is_displayed' => sub {
    it 'should detect element visibility' => sub {
        ok elem('h1')->is_displayed;
    };
};
describe 'Brownie::Node::Selenium#is_not_displayed' => sub {
    it 'should detect element visibility' => sub {
        ok elem('#input_hidden')->is_not_displayed;
    };
};

describe 'Brownie::Node::Selenium#is_checked' => sub {
    it 'should detect checkbox state' => sub {
        ok elem('#input_checkbox2')->is_checked;
    };
};
describe 'Brownie::Node::Selenium#is_not_checked' => sub {
    it 'should detect checkbox state' => sub {
        ok elem('#input_checkbox1')->is_not_checked;
    };
};

describe 'Brownie::Node::Selenium#is_selected' => sub {
    it 'should detect radio button state' => sub {
        ok $driver->find_element('#input_radio2')->is_selected;
    };
};
describe 'Brownie::Node::Selenium#is_not_selected' => sub {
    it 'should detect radio button state' => sub {
        ok $driver->find_element('#input_radio1')->is_not_selected;
    };
};

done_testing;
