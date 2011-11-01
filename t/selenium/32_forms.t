use Test::More;
use Test::Flatten;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Session;
use t::Helper;
use File::Spec;

my $session = Brownie::Session->new(driver_name => 'Selenium');
my $httpd = test_httpd;

describe 'Brownie::Session#fill_in' => sub {
    sub fill_in_ok {
        my ($locator, $id) = @_;
        $session->visit($httpd->endpoint);
        my $value = time . $$;
        $session->fill_in($locator, $value);
        is $session->find_element("#$id")->value => $value;
    }

    it 'should fill in value to text field' => sub {
        fill_in_ok('input_text', 'input_text');
        fill_in_ok('Input Text Title', 'input_text');
        fill_in_ok('Input Text Label', 'input_text');
        fill_in_ok('Inner Input Password Lavel', 'input_password');
    };
    it 'should fill in value to textarea' => sub {
        fill_in_ok('textarea', 'textarea');
        fill_in_ok('Textarea Label', 'textarea');
        fill_in_ok('Inner Textarea Lavel', 'textarea2');
    };
};

describe 'Brownie::Session#choose' => sub {
    sub choose_ok {
        my ($locator, $id) = @_;
        $session->visit($httpd->endpoint);
        ok $session->find_element("#$id")->is_not_selected;
        $session->choose($locator);
        ok $session->find_element("#$id")->is_selected;
    }

    it 'should choose on radio' => sub {
        choose_ok('input_radio1', 'input_radio1');
        choose_ok('Radio1 Value', 'input_radio1');
        choose_ok('radio1', 'input_radio1');
        choose_ok('radio3', 'input_radio3');
    };
};

describe 'Brownie::Session#check' => sub {
    sub check_ok {
        my ($locator, $id) = @_;
        $session->visit($httpd->endpoint);
        ok $session->find_element("#$id")->is_not_checked;
        $session->check($locator);
        ok $session->find_element("#$id")->is_checked;
    }

    it 'should mark on checkbox' => sub {
        check_ok('input_checkbox1', 'input_checkbox1');
        check_ok('Checkbox1 Value', 'input_checkbox1');
        check_ok('checkbox1', 'input_checkbox1');
        check_ok('checkbox4', 'input_checkbox4');
    };
};

describe 'Brownie::Session#uncheck' => sub {
    sub uncheck_ok {
        my ($locator, $id) = @_;
        $session->visit($httpd->endpoint);
        ok $session->find_element("#$id")->is_checked;
        $session->uncheck($locator);
        ok $session->find_element("#$id")->is_not_checked;
    }

    it 'should mark out checkbox' => sub {
        uncheck_ok('input_checkbox3', 'input_checkbox3');
        uncheck_ok('Checkbox3 Value', 'input_checkbox3');
        uncheck_ok('checkbox3', 'input_checkbox3');
        uncheck_ok('checkbox2', 'input_checkbox2');
    };
};

describe 'Brownie::Session#select' => sub {
    sub select_ok {
        my ($locator, $id) = @_;
        $session->visit($httpd->endpoint);
        ok $session->find_element("#$id")->is_not_selected;
        $session->select($locator);
        ok $session->find_element("#$id")->is_selected;
    }

    it 'should mark on option' => sub {
        select_ok('select_option1', 'select_option1');
        select_ok('3', 'select_option3');
        select_ok('o4', 'select_option4');
    };
};

describe 'Brownie::Session#unselect' => sub {
    sub unselect_ok {
        my ($locator, $id) = @_;
        $session->visit($httpd->endpoint);
        ok $session->find_element("#$id")->is_selected;
        $session->unselect($locator);
        ok $session->find_element("#$id")->is_not_selected;
    }

    it 'should mark out option in multiple selection' => sub {
        unselect_ok('select_option5', 'select_option5');
        unselect_ok('5', 'select_option5');
        unselect_ok('o5', 'select_option5');
    };
};

describe 'Brownie::Session#attach_file' => sub {
    sub attach_ok {
        my ($locator, $id) = @_;
        $session->visit($httpd->endpoint);
        ok !$session->find_element("#$id")->value;

        my $path = File::Spec->rel2abs($0);
        $session->attach_file($locator, $path);
        is $session->find_element("#$id")->value => $path;
    }

    it 'should set path to input field' => sub {
        attach_ok('input_file1', 'input_file1');
        attach_ok('File Label1', 'input_file1');
        attach_ok('File Label2', 'input_file2');
    };
};

done_testing;
