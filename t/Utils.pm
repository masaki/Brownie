package t::Utils;

use strict;
use warnings;
use parent 'Exporter';
use Test::Fake::HTTPD;
use Brownie::Session;

our @EXPORT = qw(
    create_session_for
    run_httpd_with
);

sub create_session_for {
    my ($driver) = @_;
    Brownie::Session->new(driver => $driver);
}

sub run_httpd_with {
    my $content = shift;

    my $httpd = Test::Fake::HTTPD->new(timeout => 30);
    $httpd->run(sub {
        my $req = shift;
        my $body = sprintf $content, $req->uri->path;
        return [ 200, [ 'Content-Type' => 'text/html ;charset=utf-8' ], [ $body ] ];
    });

    $httpd;
}

1;
