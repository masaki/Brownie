use Test::More;
use Test::Flatten;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;

describe 'Brownie::Driver::Selenium.browser' => sub {
    my $browser = Brownie::Driver::Selenium->browser;

    it 'should returns Selenium::Remote::Driver object' => sub {
        isa_ok $browser => 'Selenium::Remote::Driver';
    };

    it 'should instantiate $Brownie::Driver::Selenium::Browser' => sub {
        ok $Brownie::Driver::Selenium::Browser;
        isa_ok $Brownie::Driver::Selenium::Browser => 'Selenium::Remote::Driver';
    };
};

done_testing;
