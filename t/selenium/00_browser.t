use Test::More;
use Test::Flatten;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;

describe 'Brownie::Driver::Selenium#browser' => sub {
    my $driver = Brownie::Driver::Selenium->new;
    my $browser = $driver->browser;

    it 'should returns Selenium::Remote::Driver object' => sub {
        isa_ok $browser => 'Selenium::Remote::Driver';
    };

    it 'should have browser object' => sub {
        ok $driver->{browser};
        isa_ok $driver->{browser} => 'Selenium::Remote::Driver';
    };
};

done_testing;
