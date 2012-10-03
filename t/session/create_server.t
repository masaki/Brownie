use strict;
use warnings;
use Test::More;
use Brownie::Session;
use File::Temp;

subtest 'spawn PSGI from app sub' => sub {
    my $app = sub { [ 201, [ 'Content-Type' => 'text/html' ], [ 'Created' ] ] };

    my $bs = Brownie::Session->new(app => $app);
    ok $bs->app_host;
    like $bs->app_host => qr/localhost/;

    $bs->visit('/');
    is $bs->current_url => $bs->app_host . '/';
    is $bs->status_code => 201;
    is $bs->body        => 'Created';
};

subtest 'spawn PSGI from file' => sub {
    my $fh = File::Temp->new(UNLINK => 1);
    print $fh "sub { [ 202, [ 'Content-Type' => 'text/html' ], [ 'Accepted' ] ] };";
    close $fh;

    my $bs = Brownie::Session->new(app => $fh->filename);
    ok $bs->app_host;
    like $bs->app_host => qr/localhost/;

    $bs->visit('/');
    is $bs->current_url => $bs->app_host . '/';
    is $bs->status_code => 202;
    is $bs->body        => 'Accepted';
};

done_testing;
