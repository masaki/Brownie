package Brownie::Node::Mechanize;

use strict;
use warnings;
use parent 'Brownie::Node';

sub _mech { shift->driver->browser }

sub _is_link {
    my $self = shift;
    return $self->tag_name eq 'a' and $self->attr('href');
}

sub _is_button {
    my $self = shift;
    my $tag  = $self->tag_name;
    my $type = $self->attr('type') || '';
    return 1 if $tag eq 'input'  and ($type eq 'submit' or $type eq 'image');
    return 1 if $tag eq 'button' and (!$type or $type eq 'submit');
    return 0;
}

sub _is_checkbox {
    my $self = shift;
    return $self->tag_name eq 'input' and $self->attr('type') and $self->attr('type') eq 'checkbox';
}

sub _is_radio {
    my $self = shift;
    return $self->tag_name eq 'input' and $self->attr('type') and $self->attr('type') eq 'radio';
}

sub attr {
    my ($self, $name) = @_;
    return $self->native->attr($name) || '';
}

sub value {
    my $self = shift;
    return $self->tag_name eq 'textarea' ? $self->text : $self->attr('value');
}

sub text {
    my $self = shift;
    return $self->native->as_text;
}

sub tag_name {
    my $self = shift;
    return lc $self->native->tag;
}

sub find_element {
    my ($self, $locator) = @_;
    return $self->driver->find_element($locator, -base => $self);
}

sub find_elements {
    my ($self, $locator) = @_;
    my @children = $self->driver->find_elements($locator, -base => $self);
    return @children ? @children : ();
}

sub is_displayed {
    my $self = shift;

    my @hidden = $self->native->look_up(sub {
        return 1 if $_[0]->attr('style') and $_[0]->attr('style') =~ /display:\s*none/i;
        return 1 if $_[0]->tag =~ /^(?:script|head)$/i;
        return 1 if $_[0]->tag =~ /^input$/i and $_[0]->attr('type') and $_[0]->attr('type') =~ /hidden/i;
        return 0;
    });

    return @hidden ? 0 : 1;
}

sub is_selected {
    my $self = shift;
    return $self->attr('selected') || $self->attr('checked');
}

*is_checked = \&is_selected; # alias

sub set {
    my ($self, $value) = @_;

    if ($self->tag_name eq 'input' and $self->attr('type') =~ /(?:checkbox|radio)/) {
        $self->select;
    }
    elsif ($self->tag_name eq 'input') {
        $self->native->attr(value => $value);
    }
    elsif ($self->tag_name eq 'textarea') {
        $self->native->delete_content;
        $self->native->push_content($value);
    }
}

sub select {
    my $self = shift;
    my $mech = $self->_mech;

    if ($self->_is_checkbox) {
        $mech->tick($self->attr('name'), $self->value) if $self->is_not_selected;
    }
    elsif ($self->_is_radio) {
        $mech->set_visible([ radio => $self->value ]) if $self->is_not_selected;
    }
    elsif ($self->tag_name eq 'option') {
        $mech->select($self->attr('name'), $self->value) if $self->is_not_selected;
    }
}

sub unselect {
    my $self = shift;
    my $mech = $self->_mech;

    if ($self->_is_checkbox) {
        $mech->untick($self->attr('name'), $self->value) if $self->is_selected;
    }
    elsif ($self->tag_name eq 'option') {
        # TODO: check if multiple select options
    }
}

sub click {
    my $self = shift;
    my $mech = $self->_mech;

    if ($self->_is_link) {
        return $mech->follow_link(url => $self->attr('href'));
    }
    elsif ($self->_is_button) {
        my $name = $self->attr('name');
        return $mech->click_button($name ? (name => $name) : (value => $self->value));
    }
    elsif ($self->_is_checkbox) {
        my $modifier = $self->is_checked ? 'untick' : 'tick';
        return $mech->$modifier($self->attr('name'), $self->value);
    }
    elsif ($self->_is_radio) {
        return $mech->set_visible([ radio => $self->value ]);
    }
    elsif ($self->tag_name eq 'option') {
        return $mech->select($self->attr('name'), $self->value);
    }
}

1;

=head1 NAME

Brownie::Node::Mechanize - base class of Brownie::Node series

=head1 DESCRIPTION

Please see L<Brownie::Node> document.

=head1 METHODS

=head2 IMPLEMENTED

=over 4

=item * C<attr>

=item * C<value>

=item * C<text>

=item * C<tag_name>

=item * C<is_displayed>

=item * C<is_checked>

=item * C<is_selected>

=item * C<set($value)>

=item * C<select>

=item * C<unselect>

=item * C<click>

=item * C<find_element($locator)>

=item * C<find_elements($locator)>

=back

=head2 OVERRIDED

=over 4

=item * C<new(%args)>

=item * C<driver>

=item * C<native>

=item * C<is_not_displayed>

=item * C<is_not_checked>

=item * C<is_not_selected>

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Brownie::Node>, L<Brownie::Driver>, L<Brownie::Driver::Mechanize>

L<HTML::Element>, L<WWW::Mechanize>

=cut
