package Test::Brownie::SharedExamples::Session;

use strict;
use warnings;
use parent 'Exporter';
use Test::More;
use File::Spec;

sub import { __PACKAGE__->export_to_level(2, @_) }

sub session_support_click_action {
    my ($session, $base_url) = @_;

    subtest 'click_link' => sub {
        my @locator = (
            'link_id',
            'Text of Link',
            'Title of Link',
            'Alt of Image',
        );

        for my $locator (@locator) {
            $session->visit($base_url);
            ok $session->click_link($locator);
            isnt $session->current_url => $base_url;
        }
    };

    subtest 'click_button' => sub {
        my @locator = (
            'input_submit',
            'input_image',
            'button_submit',
            'Input Submit Title', 'Input Submit Value',
            'Button Submit Title', 'Button Submit Value', 'Button Submit',
        );

        for my $locator (@locator) {
            $session->visit($base_url);
            ok $session->click_button($locator);
            is $session->current_path => '/form';
        }
    };

    subtest 'click_on' => sub {
        my @locator = (
            'link_id',
            'Input Submit Title',
        );

        for my $locator (@locator) {
            $session->visit($base_url);
            $session->click_on($locator);
            isnt $session->current_url => $base_url;
        }
    };
}

sub session_support_form_action {
    my ($session, $base_url) = @_;

    subtest 'fill_in' => sub {
        my @params = (
            ['input_text', 'input_text'],
            ['Input Text Title', 'input_text'],
            ['Input Text Label', 'input_text'],
            ['Inner Input Password Lavel', 'input_password'],
            ['textarea', 'textarea'],
            ['Textarea Label', 'textarea'],
            ['Inner Textarea Lavel', 'textarea2'],
        );

        for (@params) {
            my ($locator, $id) = @$_;
            $session->visit($base_url);

            my $value = time . $$;
            ok $session->fill_in($locator, $value);
            is $session->find_element("#$id")->value => $value;
        }
    };

    subtest 'choose' => sub {
        my @params = (
            ['input_radio1', 'input_radio1'],
            ['Radio1 Value', 'input_radio1'],
            ['radio1', 'input_radio1'],
            ['radio3', 'input_radio3'],
        );

        for (@params) {
            my ($locator, $id) = @$_;
            $session->visit($base_url);

            my $node = $session->find_element("#$id");
            ok $node->is_not_selected;
            ok $session->choose($locator);
            ok $node->is_selected;
        }
    };

    subtest 'check' => sub {
        my @params = (
            ['input_checkbox1', 'input_checkbox1'],
            ['Checkbox1 Value', 'input_checkbox1'],
            ['checkbox1', 'input_checkbox1'],
            ['checkbox4', 'input_checkbox4'],
        );

        for (@params) {
            my ($locator, $id) = @$_;
            $session->visit($base_url);

            my $node = $session->find_element("#$id");
            ok $node->is_not_checked;
            ok $session->check($locator);
            ok $node->is_checked;
        }
    };

    subtest 'uncheck' => sub {
        my @params = (
            ['input_checkbox3', 'input_checkbox3'],
            ['Checkbox3 Value', 'input_checkbox3'],
            ['checkbox3', 'input_checkbox3'],
            ['checkbox2', 'input_checkbox2'],
        );

        for (@params) {
            my ($locator, $id) = @$_;
            $session->visit($base_url);

            my $node = $session->find_element("#$id");
            ok $node->is_checked;
            ok $session->uncheck($locator);
            ok $node->is_not_checked;
        }
    };

    subtest 'select' => sub {
        my @params = (
            ['select_option1', 'select_option1'],
            ['3', 'select_option3'],
            ['o4', 'select_option4'],
        );

        for (@params) {
            my ($locator, $id) = @$_;
            $session->visit($base_url);

            my $node = $session->find_element("#$id");
            ok $node->is_not_selected;
            ok $session->select($locator);
            ok $node->is_selected;
        }
    };

    subtest 'unselect' => sub {
        my @params = (
            ['select_option5', 'select_option5'],
            ['5', 'select_option5'],
            ['o5', 'select_option5'],
        );

        for (@params) {
            my ($locator, $id) = @$_;
            $session->visit($base_url);

            my $node = $session->find_element("#$id");
            ok $node->is_selected;
            ok $session->select($locator);
            ok $node->is_not_selected;
        }
    };

    subtest 'attach_file' => sub {
        my @params = (
            ['input_file1', 'input_file1'],
            ['File Label1', 'input_file1'],
            ['File Label2', 'input_file2'],
        );

        for (@params) {
            my ($locator, $id) = @$_;
            $session->visit($base_url);

            my $node = $session->find_element("#$id");
            ok !($node->value);

            my $path = File::Spec->rel2abs($0);
            $session->attach_file($locator, $path);
            is $node->value => $path;
        }
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
