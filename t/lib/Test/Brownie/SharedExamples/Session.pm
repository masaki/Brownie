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
        my $harness = sub {
            my $locator = shift;
            $session->visit($base_url);
            $session->click_link($locator);
            isnt $session->current_url => $base_url;
        };

        $harness->('link_id');
        $harness->('Text of Link');
        $harness->('Title of Link');
        $harness->('Alt of Image');
    };

    subtest 'click_button' => sub {
        my $harness = sub {
            my $locator = shift;
            $session->visit($base_url);
            $session->click_button($locator);
            isnt $session->current_url => $base_url;
        };

        my @id = qw(input_submit input_image button_submit);
        for my $id (@id) {
            $harness->($id);
        }

        $harness->('Input Submit Title');
        $harness->('Input Submit Value');

        $harness->('Button Submit Title');
        $harness->('Button Submit Value');
        $harness->('Button Submit');
    };

    subtest 'click_on' => sub {
        my $harness = sub {
            my $locator = shift;
            $session->visit($base_url);
            $session->click_on($locator);
            isnt $session->current_url => $base_url;
        };

        $harness->('link_id');
        $harness->('Input Submit Title');
    };
}

sub session_support_form_action {
    my ($session, $base_url) = @_;

    subtest 'fill_in' => sub {
        my $harness = sub {
            my ($locator, $id) = @_;
            $session->visit($base_url);

            my $value = time . $$;
            $session->fill_in($locator, $value);
            is $session->find_element("#$id")->value => $value;
        };

        $harness->('input_text', 'input_text');
        $harness->('Input Text Title', 'input_text');
        $harness->('Input Text Label', 'input_text');
        $harness->('Inner Input Password Lavel', 'input_password');

        $harness->('textarea', 'textarea');
        $harness->('Textarea Label', 'textarea');
        $harness->('Inner Textarea Lavel', 'textarea2');
    };

    subtest 'choose' => sub {
        my $harness = sub {
            my ($locator, $id) = @_;
            $session->visit($base_url);

            ok $session->find_element("#$id")->is_not_selected;
            $session->choose($locator);
            ok $session->find_element("#$id")->is_selected;
        };

        $harness->('input_radio1', 'input_radio1');
        $harness->('Radio1 Value', 'input_radio1');
        $harness->('radio1', 'input_radio1');
        $harness->('radio3', 'input_radio3');
    };

    subtest 'check' => sub {
        my $harness = sub {
            my ($locator, $id) = @_;
            $session->visit($base_url);

            ok $session->find_element("#$id")->is_not_checked;
            $session->check($locator);
            ok $session->find_element("#$id")->is_checked;
        };

        $harness->('input_checkbox1', 'input_checkbox1');
        $harness->('Checkbox1 Value', 'input_checkbox1');
        $harness->('checkbox1', 'input_checkbox1');
        $harness->('checkbox4', 'input_checkbox4');
    };

    subtest 'uncheck' => sub {
        my $harness = sub {
            my ($locator, $id) = @_;
            $session->visit($base_url);

            ok $session->find_element("#$id")->is_checked;
            $session->uncheck($locator);
            ok $session->find_element("#$id")->is_not_checked;
        };

        $harness->('input_checkbox3', 'input_checkbox3');
        $harness->('Checkbox3 Value', 'input_checkbox3');
        $harness->('checkbox3', 'input_checkbox3');
        $harness->('checkbox2', 'input_checkbox2');
    };

    subtest 'select' => sub {
        my $harness = sub {
            my ($locator, $id) = @_;
            $session->visit($base_url);

            ok $session->find_element("#$id")->is_not_selected;
            $session->select($locator);
            ok $session->find_element("#$id")->is_selected;
        };

        $harness->('select_option1', 'select_option1');
        $harness->('3', 'select_option3');
        $harness->('o4', 'select_option4');
    };

    subtest 'unselect' => sub {
        my $harness = sub {
            my ($locator, $id) = @_;
            $session->visit($base_url);

            ok $session->find_element("#$id")->is_selected;
            $session->unselect($locator);
            ok $session->find_element("#$id")->is_not_selected;
        };

        $harness->('select_option5', 'select_option5');
        $harness->('5', 'select_option5');
        $harness->('o5', 'select_option5');
    };

    subtest 'attach_file' => sub {
        my $harness = sub {
            my ($locator, $id) = @_;
            $session->visit($base_url);

            ok !$session->find_element("#$id")->value;
            my $path = File::Spec->rel2abs($0);
            $session->attach_file($locator, $path);
            is $session->find_element("#$id")->value => $path;
        };

        $harness->('input_file1', 'input_file1');
        $harness->('File Label1', 'input_file1');
        $harness->('File Label2', 'input_file2');
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
