#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use Brownie::Session;

my $session = Brownie::Session->new(driver_name => 'Selenium');
$session->visit('http://www.google.com/webhp');

like $session->title => qr/Google/;

$session->fill_in('q' => "Brownie\n"); # enable auto-search
sleep 3;

like $session->title => qr/Brownie/i;

done_testing;
