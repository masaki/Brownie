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

  use Brownie::Session;
  my $session = Brownie::Session->new;

  my $node = $session->find_element('#id');

=head1 METHODS

=over 4

=item * C<new(%args)>

Returns a new instance.

  my $node = Brownie::Node->new(%args);

C<%args> are:

=over 8

=item * C<driver>: parent Brownie::Driver instance

=item * C<native>: native driver specific node representation instance

=back

=item * C<driver>

Returns a driver instance.

  my $driver = $node->driver;

=item * C<native>

Returns a native node instance.

  my $native = $node->native;

=item * C<attr($name)>

Returns an attribute value.

  my $title = $node->attr('title');

=item * C<value>

Returns the value of element.

  my $value = $node->value;

=item * C<text>

Returns a child node text. (= innerText)

  my $text = $node->text;

=item * C<tag_name>

Returns a tag name.

  my $tag_name = $node->tag_name;

=item * C<is_displayed>, C<is_not_displayed>

Whether this element is displayed, or not.

  if ($node->is_displayed) {
      print "this node is visible";
  }

  if ($node->is_not_displayed) {
      warn "this node is not visible";
  }

=item * C<is_checked>, C<is_not_checked>

Whether this element is checked, or not. (checkbox)

  if ($checkbox->is_checked) {
      print "marked";
  }

  if ($checkbox->is_not_checked) {
      warn "unmarked...";
  }

=item * C<is_selected>, C<is_not_selected>

Whether this element is selected, or not. (radio, option)

  if ($radio->is_selected) {
      print "this radio button is selcted";
  }

  if ($option->is_not_selected) {
      warn "this option element is not selected";
  }

=item * C<set($value)>

Sets value to this element. (input, textarea)

  $input->set($value);
  $textarea->set($text);

=item * C<select>

Select this element (option, radio)

  $option->select;
  $radio->select;

=item * C<unselect>

Unselect this element (options - multiple select)

  $option->unselect;

=item * C<click>

Clicks this element.

  $link->click;
  $button->click;

=item * C<find_element($locator)>

Finds and returns an located element under this.

  my $element = $node->find_element($locator); # search under $node

=item * C<find_elements($locator)>

Finds and returns located elements under this.

  my @elements = $node->find_elements($locator); # search under $node

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
