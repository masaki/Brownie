package Brownie::Node::Mechanize;

use strict;
use warnings;
use parent 'Brownie::Node';

# shortcut
for my $name (qw(id name type)) {
    no strict 'refs';
    *{"_${name}"} = sub { return shift->attr($name) || '' };
}

sub _selector {
    my $self = shift;

    my $selector = '';
    if (my $id = $self->_id) {
        $selector = "#$id";
    }
    elsif (my $name = $self->_name) {
        $selector = "^$name";
    }

    return $selector;
}

sub _is_in_link {
    my $self = shift;
    return $self->native->look_up(sub {
        return lc($_[0]->tag) eq 'a' && $_[0]->attr('href');
    });
}

sub _detect_link {
    my $self = shift;
    my @links = $self->_is_in_link;
    return @links ? shift(@links)->attr('href') : '';
}

sub _is_text_field {
    my $self = shift;
    return 1 if $self->tag_name eq 'textarea';
    return 1 if $self->tag_name eq 'input' && $self->_type =~ /^(?:text|password|hidden)$/i;
    return 0;
}

sub _is_button {
    my $self = shift;
    return 1 if $self->tag_name eq 'input'  && $self->_type =~ /^(?:submit|image)$/i;
    return 1 if $self->tag_name eq 'button' && (!$self->_type || $self->_type eq 'submit');
    return 0;
}

sub _is_checkbox {
    my $self = shift;
    return $self->tag_name eq 'input' && $self->_type eq 'checkbox';
}

sub _is_radio {
    my $self = shift;
    return $self->tag_name eq 'input' && $self->_type eq 'radio';
}

sub _is_option {
    my $self = shift;
    return $self->tag_name eq 'option';
}

sub _is_in_multiple_select {
    my $self = shift;

    return $self->native->look_up(sub {
        return lc($_[0]->tag) eq 'select' && $_[0]->attr('multiple');
    });
}

sub attr {
    my ($self, $name) = @_;
    return $self->native->attr($name) || '';
}

sub value {
    my $self = shift;
    return $self->_mech->value($self->_selector) || '';
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

sub _mech { return shift->driver->browser }

sub _is_form_control {
    my $self = shift;
    return $self->_is_text_field
        || $self->_is_button
        || $self->_is_checkbox
        || $self->_is_radio
        || $self->_is_option;
}

sub _as_html_form {
    my $self = shift;

    if ($self->_is_form_control) {
        for my $form ($self->_mech->forms) {
            my $input = $form->find_input($self->_selector);
            return $input if $input;
        }
    }

    return;
}

sub is_displayed { !shift->is_not_displayed }

sub is_not_displayed {
    my $self = shift;

    my @hidden = $self->native->look_up(sub {
        return 1 if lc($_[0]->attr('style') || '') =~ /display\s*:\s*none/;
        return 1 if lc($_[0]->tag) eq 'script' || lc($_[0]->tag) eq 'head';
        return 1 if lc($_[0]->tag) eq 'input' && lc($_[0]->attr('type') || '') eq 'hidden';
        return 0;
    });

    return scalar(@hidden) > 0;
}

sub is_selected {
    my $self = shift;
    return $self->attr('selected') || $self->attr('checked');
}

*is_checked = \&is_selected;

sub set {
    my ($self, $value) = @_;

    if ($self->_is_text_field) {
        $self->_mech->field($self->_selector, $value);
    }
    elsif ($self->_is_checkbox || $self->_is_radio) {
        $self->select;
    }
}

sub select {
    my $self = shift;

    if ($self->_is_checkbox) {
        $self->_mech->tick($self->_selector, $self->value);
        $self->native->attr(checked => 'checked');
    }
    elsif ($self->_is_radio) {
        $self->_mech->set_visible([ radio => $self->value ]);
        $self->native->attr(selected => 'selected');
    }
    elsif ($self->_is_option) {
        $self->_mech->select($self->_selector, $self->value);
        $self->native->attr(selected => 'selected');
    }
}

sub unselect {
    my $self = shift;

    if ($self->_is_checkbox) {
        $self->_mech->untick($self->_selector, $self->value);
        $self->native->attr(checked => '');
    }
    elsif ($self->_is_option && $self->_is_in_multiple_select) {
        $self->_mech->field($self->_selector, undef);
        $self->native->attr(selected => '');
    }
}

sub click {
    my $self = shift;

    if ($self->_is_in_link) {
        $self->_mech->follow_link(url => $self->_detect_link);
    }
    elsif ($self->_is_button) {
        $self->_mech->click_button($self->_name ? (name => $self->_name) : (value => $self->value));
    }
    elsif ($self->_is_checkbox || $self->_is_option) {
        $self->is_checked ? $self->unselect : $self->select;
    }
    elsif ($self->_is_radio) {
        $self->select;
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
