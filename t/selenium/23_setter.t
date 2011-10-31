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

describe 'Brownie::Node::Selenium#set' => sub {
    $driver->visit($httpd->endpoint);

    sub should_set_new_text {
        my ($locator, $old) = @_;
        my $elem = elem($locator);
        is $elem->value => $old;
        my $new = $old . time;
        $elem->set($new);
        is $elem->value => $new;
    }

    it 'should set text to input' => sub {
        should_set_new_text('#input_text', 'Input Text Value');
    };

    it 'should set text to textarea' => sub {
        should_set_new_text('#textarea', 'Textarea Text');
    };

    sub should_select_using_set {
        my $locator = shift;
        my $elem = elem($locator);
        ok $elem->is_not_checked;
        $elem->set;
        ok $elem->is_checked;
    };

    it 'should alias to select on checkbox or radio button' => sub {
        should_select_using_set('#input_checkbox1');
        should_select_using_set('#input_radio1');
    };
};

done_testing;
