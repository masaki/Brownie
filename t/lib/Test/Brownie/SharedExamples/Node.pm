package Test::Brownie::SharedExamples::Node;

use strict;
use warnings;
use parent 'Exporter';
use Test::More;

sub import { __PACKAGE__->export_to_level(2, @_) }

sub node_support_read_access {
    my $driver = shift;

    subtest 'should access to element information' => sub {
        my $element = $driver->find_element('h1');
        is $element->attr('id') => 'current_path';
        is $element->text => '/';
        is $element->tag_name => 'h1';
    };

    subtest 'should access to value of input element' => sub {
        my $element = $driver->find_element('#input_submit');
        is $element->value => 'Input Submit Value';
    };
}

sub node_support_inner_finder {
    my $driver = shift;

    my $parent = $driver->find_element('p#parent');

    subtest 'should get elements under specified element' => sub {
        my @children = $parent->find_elements('a');
        is scalar(@children) => 2;
        is $children[0]->text => 'child3';
        is $children[1]->text => 'child4';

        my @anchors = $driver->find_elements('a');
        cmp_ok scalar(@anchors), '>', scalar(@children);
    };

    subtest 'should get an element under specified element' => sub {
        my $child = $parent->find_element('a');
        is $child->text => 'child3';
    };
}

sub node_support_state_check {
    my $driver = shift;

    ok $driver->find_element('h1')->is_displayed;
    ok $driver->find_element('#input_hidden')->is_not_displayed;
    ok $driver->find_element('#input_checkbox2')->is_checked;
    ok $driver->find_element('#input_checkbox1')->is_not_checked;
    ok $driver->find_element('#input_radio2')->is_selected;
    ok $driver->find_element('#input_radio1')->is_not_selected;
}

sub node_support_form_action {
    my $driver = shift;

    subtest 'check on checkbox' => sub {
        my $checkbox = $driver->find_element('#input_checkbox1');
        ok $checkbox->is_not_checked;
        $checkbox->select;
        ok $checkbox->is_checked;
    };

    subtest 'select on radio button' => sub {
        my $radio = $driver->find_element('#input_radio1');
        ok $radio->is_not_selected;
        $radio->select;
        ok $radio->is_selected;
    };

    subtest 'select on option' => sub {
        my $option = $driver->find_element('#select_option1');
        ok $option->is_not_selected;
        $option->select;
        ok $option->is_selected;
    };

    subtest 'check out checkbox' => sub {
        my $checkbox = $driver->find_element('#input_checkbox2');
        ok $checkbox->is_checked;
        $checkbox->unselect;
        ok $checkbox->is_not_checked;
    };

    subtest 'select out multiple option' => sub {
        my $option = $driver->find_element('#select_option5');
        ok $option->is_selected;
        $option->unselect;
        ok $option->is_not_selected;
    };

    subtest 'set text' => sub {
        my $harness = sub {
            my ($locator, $old) = @_;
            my $elem = $driver->find_element($locator);

            is $elem->value => $old;
            my $new = $old . time;
            $elem->set($new);
            is $elem->value => $new;
        };

        $harness->('#input_text', 'Input Text Value');
        $harness->('#textarea', 'Textarea Text');
    };

    subtest 'click elements' => sub {
        my $link = $driver->find_element('#link_id');
        $link->click;
        is $driver->current_path => '/id';

        my $button = $driver->find_element('#input_submit');
        $button->click;
        is $driver->current_path => '/form';
    };
}

our @EXPORT;
{
    my $class = __PACKAGE__;
    no strict 'refs';
    for my $k (keys %{"${class}::"}) {
        next if $k =~ /^_/;
        next if $k =~ /^(?:BEGIN|CHECK|END|DESTROY)$/;
        next if $k =~ /^(?:import)$/;
        next unless *{"${class}::${k}"}{CODE};
        push @EXPORT, $k;
    }
}

1;
