use strict;
use warnings;
use Test::More;
use t::Utils;
use Test::Exception;
use Brownie::Driver::Mechanize;

my $driver = Brownie::Driver::Mechanize->new;

subtest 'Scripting' => sub {
    subtest 'execute_script' => sub {
        dies_ok { $driver->execute_script("document.title='execute_script'") } 'not supported execute_script()';
    };

    subtest 'evaluate_script' => sub {
        dies_ok { $driver->evaluate_script('1 + 2') } 'not supported evaluate_script()';
    };
};

done_testing;
