use strict;
use warnings;
use Test::More;
use Test::Exception;
use Brownie::Driver::SeleniumServer;

my $driver = Brownie::Driver::SeleniumServer->new;

subtest 'Headers' => sub {
    subtest 'status_code' => sub {
        dies_ok { $driver->status_code } 'not supported status_code()';
    };

    subtest 'response_headers' => sub {
        dies_ok { $driver->response_headers } 'not supported response_headers()';
    };
};

done_testing;
