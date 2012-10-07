package Brownie::Node::SeleniumServer;

use strict;
use warnings;
use parent 'Brownie::Node';

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

sub set {
    my ($self, $value) = @_;

    if ($self->tag_name eq 'input' and $self->type =~ /(?:checkbox|radio)/) {
        $self->select;
    }
    elsif ($self->tag_name eq 'input' or $self->tag_name eq 'textarea') {
        $self->native->clear if $self->type ne 'file';
        $self->native->send_keys($value);
    }
}

sub select {
    my $self = shift;
    $self->click unless $self->is_selected;
}

sub unselect {
    my $self = shift;
    # TODO: check if multiple select options
    $self->click if $self->is_selected;
}

sub click {
    my $self = shift;
    $self->native->click;
}

1;

=head1 NAME

Brownie::Node::SeleniumServer

=head1 METHODS

=over 4

=item * C<new(%args)>

=item * C<driver>

=item * C<native>

=item * C<attr($name)>

=item * C<id>

=item * C<name>

=item * C<type>

=item * C<value>

=item * C<text>

=item * C<tag_name>

=item * C<is_displayed>

=item * C<is_checked>

=item * C<is_selected>

=item * C<is_not_displayed>

=item * C<is_not_checked>

=item * C<is_not_selected>

=item * C<set($value)>

=item * C<select>

=item * C<unselect>

=item * C<click>

=item * C<find($locator)>

=item * C<all($locator)>

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Brownie::Node>, L<Selenium::Remote::WebElement>

=cut
