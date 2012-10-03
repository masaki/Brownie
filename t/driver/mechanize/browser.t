use strict;
use warnings;
use Test::More;
use Brownie::Driver::Mechanize;

my $driver = Brownie::Driver::Mechanize->new;

subtest 'Browser' => sub {
    ok $driver->browser;
    isa_ok $driver->browser => 'WWW::Mechanize';
};

done_testing;
