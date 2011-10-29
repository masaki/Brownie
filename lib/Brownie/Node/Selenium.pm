package Brownie::Node::Selenium;

use strict;
use warnings;
use parent 'Brownie::Node';

### Getter

sub attr {
    my ($self, $name) = @_;
    return $self->native->get_attribute($name);
}

sub value {
    my $self = shift;
    return $self->native->get_value;
}

sub text {
    my $self = shift;
    return $self->native->get_text;
}

sub tag_name {
    my $self = shift;
    return lc $self->native->get_tag_name;
}

### Setter

sub set {
    my ($self, $value) = @_;

    if ($self->tag_name eq 'input' and $self->attr('type') =~ /(?:checkbox|radio)/) {
        $self->select;
    }
    elsif ($self->tag_name eq 'input' or $self->tag_name eq 'textarea') {
        $self->native->clear;
        $self->native->send_keys($value);
    }
}

sub select {
    my $self = shift;
    $self->click unless $self->is_selected;
}

sub unselect {
    my $self = shift;
    $self->click if $self->is_selected;
}

### Action

sub click {
    my $self = shift;
    $self->native->click;
}

### Query

sub is_displayed {
    my $self = shift;
    return $self->native->is_displayed;
}

sub is_selected {
    my $self = shift;
    return $self->native->is_selected;
}

sub is_checked {
    my $self = shift;
    return $self->native->is_selected;
}

1;
