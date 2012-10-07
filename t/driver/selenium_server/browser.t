use strict;
use warnings;
use Test::More;
use Brownie::Driver::SeleniumServer;

my $driver = Brownie::Driver::SeleniumServer->new;

subtest 'Browser' => sub {
    ok $driver->browser;
    isa_ok $driver->browser => 'Selenium::Remote::Driver';
};

done_testing;
