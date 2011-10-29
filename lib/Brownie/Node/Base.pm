package Brownie::Node::Base;

use strict;
use warnings;
use Carp qw(croak);

sub new {
    my ($class, @args) = @_;
    return bless { @args }, $class;
}

1;
