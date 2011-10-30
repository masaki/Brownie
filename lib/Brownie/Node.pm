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
our @Setter = qw(set select unselect);
our @Action = qw(click);
our @Finder = qw(find_element find_elements);
our @Query  = qw(is_displayed is_selected is_checked);

our @Method = (@Getter, @Setter, @Action, @Query);
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

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Brownie::Driver>

L<Brownie::Node::Selenium>, L<Brownie::Node::Mechanize>

=cut
