#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use Brownie::Session;

my $bs = Brownie::Session->new(driver => 'Mechanize', app_host => 'http://www.google.com');
$bs->visit('/webhp');

like $bs->title => qr/Google/;

$bs->fill_in('q' => "Brownie\n"); # enable auto-search
sleep 3;

like $bs->title => qr/Brownie/i;

done_testing;
