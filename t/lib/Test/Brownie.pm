package Test::Brownie;

use strict;
use warnings;
use Class::Load qw(load_class);

our @Roles = qw(
    Test::Brownie::HTTPD
    Test::Brownie::Descriptive
);

sub import {
    strict->import;
    warnings->import;

    for my $class (@Roles) {
        load_class($class) && $class->import;
    }
}

1;
