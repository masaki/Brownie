use strict;
use warnings;
use Test::More;
use Test::Mock::Guard;
use Brownie::DSL;

sub reset_test {
    Brownie->reset_sessions;
    $Brownie::Driver  = 'Mechanize';
    $Brownie::AppHost = undef;
}

my $guard = mock_guard('Brownie::Driver::SeleniumServer', +{
    new => sub { bless +{}, shift },
});

subtest 'DSL methods' => sub {
    for my $method (@Brownie::DSL::DslMethods) {
        can_ok __PACKAGE__, $method;
    }
};

subtest 'page is a Brownie::Session object' => sub {
    isa_ok page, 'Brownie::Session';
    reset_test;
};

subtest 'driver' => sub {
    isa_ok page->driver, 'Brownie::Driver::Mechanize';
    reset_test;

    Brownie->driver('SeleniumServer');
    isa_ok page->driver, 'Brownie::Driver::SeleniumServer';
    reset_test;
};

subtest 'app host' => sub {
    ok ! page->app_host;
    reset_test;

    Brownie->app_host('http://example.com');
    is page->app_host, 'http://example.com';
    reset_test;
};

subtest 'app' => sub {
    ok ! page->server;
    reset_test;

    Brownie->app(sub { [ 200, [ 'Content-Type' => 'text/html' ], [ 'App' ] ] });
    ok page->server;
    reset_test;
};

done_testing;
