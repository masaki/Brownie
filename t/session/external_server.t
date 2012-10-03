use strict;
use warnings;
use Test::More;
use Brownie::Session;
use Test::Fake::HTTPD;

subtest 'use external app' => sub {
    my $httpd = Test::Fake::HTTPD->new(timeout => 30);
    $httpd->run(sub {
        return [ 200, [ 'Content-Type' => 'text/html' ], [ 'OK' ] ];
    });

    my $bs = Brownie::Session->new(app_host => $httpd->endpoint);
    ok $bs->app_host;
    is $bs->app_host => $httpd->endpoint;

    $bs->visit('/');
    is $bs->current_url => $bs->app_host . '/';
    is $bs->status_code => 200;
    is $bs->body        => 'OK';
};

done_testing;
