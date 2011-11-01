use Test::More;
use Test::Flatten;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Session;
use t::Helper;

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

done_testing;
