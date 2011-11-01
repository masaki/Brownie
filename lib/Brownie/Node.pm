package Brownie::Node;

use strict;
use warnings;
use Sub::Install;

use Brownie;

sub new {
    my ($class, %args) = @_;
    return bless { %args }, $class;
}

sub driver { shift->{driver} }
sub native { shift->{native} }

our @Getter = qw(attr value text tag_name);
our @Query  = qw(is_displayed is_not_displayed is_selected is_not_selected is_checked is_not_checked);

sub is_not_displayed { !shift->is_displayed }
sub is_not_selected  { !shift->is_selected  }
sub is_not_checked   { !shift->is_checked   }

our @Setter = qw(set select unselect);
our @Action = qw(click);
our @Finder = qw(find_element find_elements);

sub find_element {
    my ($self, $locator) = @_;
    return shift @{[ $self->find_elements($locator) ]};
}

our @Method = (@Getter, @Query, @Setter, @Action, @Finder);
for (@Method) {
    next if __PACKAGE__->can($_);
    Sub::Install::install_sub({
        code => Brownie->can('not_implemented'),
        as   => $_,
    });
}

1;

=head1 NAME

Brownie::Node - base class of Brownie::Node series

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item * C<new(%args)>

=item * C<driver>

=item * C<native>

=item * C<attr>

=item * C<value>

=item * C<text>

=item * C<tag_name>

=item * C<is_displayed>, C<is_not_displayed>

=item * C<is_checked>, C<is_not_checked>

=item * C<is_selected>, C<is_not_selected>

=item * C<set($value)>

=item * C<select>

=item * C<unselect>

=item * C<click>

=item * C<find_element($locator)>

=item * C<find_elements($locator)>

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Brownie::Driver>

L<Brownie::Node::Selenium>, L<Brownie::Node::Mechanize>

=cut
