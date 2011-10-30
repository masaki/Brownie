use Test::More;
use Test::Flatten;
use Test::Exception;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;
use Brownie::Node::Selenium;
use t::Helper;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd();

sub elem ($) { $driver->find_element($_[0]) }

describe 'Brownie::Node::Selenium#select' => sub {
    $driver->visit($httpd->endpoint);

    it 'should check on checkbox' => sub {
        my $checkbox = elem('#input_checkbox1');
        ok $checkbox->is_not_checked;
        $checkbox->select;
        ok $checkbox->is_checked;
    };

    it 'should select on radio button' => sub {
        my $radio = elem('#input_radio1');
        ok $radio->is_not_selected;
        $radio->select;
        ok $radio->is_selected;
    };

    it 'should select on option' => sub {
        my $option = elem('#select_option1');
        ok $option->is_not_selected;
        $option->select;
        ok $option->is_selected;
    };
};

describe 'Brownie::Node::Selenium#unselect' => sub {
    $driver->visit($httpd->endpoint);

    it 'should check out checkbox' => sub {
        my $checkbox = elem('#input_checkbox2');
        ok $checkbox->is_checked;
        $checkbox->unselect;
        ok $checkbox->is_not_checked;
    };

    it 'should select out multiple option' => sub {
        my $option = elem('#select_option5');
        ok $option->is_selected;
        $option->unselect;
        ok $option->is_not_selected;
    };
};

done_testing;
