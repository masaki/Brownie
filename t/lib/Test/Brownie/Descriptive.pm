package Test::Brownie::Descriptive;

use strict;
use warnings;
use parent 'Exporter';
use Test::More ();

BEGIN {
    *describe = *context = *it = \&Test::More::subtest;
}

our @EXPORT = qw(describe context it);

sub import {
    __PACKAGE__->export_to_level(2, @_);
}

1;
