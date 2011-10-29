package Brownie::Node::Base;

use strict;
use warnings;
use Carp ();

sub new {
    my ($class, %args) = @_;
    return bless { %args }, $class;
}

sub driver { shift->{driver} }
sub native { shift->{native} }

1;
