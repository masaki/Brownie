package Brownie::Node::Selenium;

use strict;
use warnings;
use parent 'Brownie::Node::Base';

sub click {
    my $self = shift;
    $self->native->click;
}

1;
