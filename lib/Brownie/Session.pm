package Brownie::Session;

use strict;
use warnings;
use Class::Load;
use Sub::Install;
use Class::Method::Modifiers;

use Brownie::Driver;
use Brownie::Node;
use Brownie::XPath;

sub new {
    my ($class, %args) = @_;

    $args{driver_name}  ||= 'Selenium';
    $args{driver_class} ||= 'Brownie::Driver::' . $args{driver_name};
    $args{driver_args}  ||= {};

    Class::Load::load_class($args{driver_class});
    my $driver = $args{driver_class}->new(%{$args{driver_args}});

    return bless { %args, scopes => [], driver => $driver }, $class;
}

sub DESTROY {
    my $self = shift;
    delete $self->{driver};
}

sub driver { shift->{driver} }
for my $method (Brownie::Driver->PROVIDED_METHODS) {
    Sub::Install::install_sub({
        code => sub { shift->driver->$method(@_) },
        as   => $method,
    });
}

sub current_node { shift->{scopes}->[-1] }

after 'visit' => sub {
    my $self = shift;
    # clear scopes
    $self->{scopes} = [ $self->document ];
};

sub _find     { $_[0]->current_node->find_element($_[1]) }
sub _click    { $_[0]->_find($_[1])->click      }
sub _set      { $_[0]->_find($_[1])->set($_[2]) }
sub _select   { $_[0]->_find($_[1])->select     }
sub _unselect { $_[0]->_find($_[1])->unselect   }

sub click_link {
    my ($self, $locator) = @_;
    my $xpath = Brownie::XPath::to_link($locator);
    return eval { $self->_click($xpath); 1 };
}

sub click_button {
    my ($self, $locator) = @_;
    my $xpath = Brownie::XPath::to_button($locator);
    return eval { $self->_click($xpath); 1 };
}

sub click_on {
    my ($self, $locator) = @_;
    return $self->click_link($locator) || $self->click_button($locator);
}

sub fill_in {
    my ($self, $locator, $value) = @_;
    my $xpath = Brownie::XPath::to_text_field($locator);
    return eval { $self->_set($xpath, $value); 1 };
}

sub choose {
    my ($self, $locator) = @_;
    my $xpath = Brownie::XPath::to_radio($locator);
    return eval { $self->_select($xpath); 1 };
}

sub check {
    my ($self, $locator) = @_;
    my $xpath = Brownie::XPath::to_checkbox($locator);
    return eval { $self->_select($xpath); 1 };
}

sub uncheck {
    my ($self, $locator) = @_;
    my $xpath = Brownie::XPath::to_checkbox($locator);
    return eval { $self->_unselect($xpath); 1 };
}

sub select {
    my ($self, $locator) = @_;
    my $xpath = Brownie::XPath::to_option($locator);
    return eval { $self->_select($xpath); 1 };
}

sub unselect {
    my ($self, $locator) = @_;
    my $xpath = Brownie::XPath::to_option($locator);
    return eval { $self->_unselect($xpath); 1 };
}

sub attach_file {
    my ($self, $locator, $filename) = @_;
    my $xpath = Brownie::XPath::to_file_field($locator);
    return eval { $self->_set($xpath, $filename); 1 };
}

1;

=head1 NAME

Brownie::Session - browser session class

=head1 SYNOPSIS

  use Test::More;
  use Brownie::Session;

  my $session = Brownie::Session->new(
      driver_name => 'Selenium', # (e.g.) 'Selenium', 'Mechanize', ...
      driver_args => { # some args for driver instantiation
          selenium_host => 'localhost',
          selenium_port => 4444,
      },
  );

  $session->visit('http://example.com');
  is $session->title => 'Example.com';

  $session->fill_in('User Name' => 'brownie');
  $session->fill_in('Email Address' => 'brownie@example.com');
  $session->click_button('Login');
  like $session->source => qr/Welcome (.+)/;

  $session->fill_in(q => 'Brownie');
  $session->click_on('Search');
  like $session->title => qr/Search result of Brownie/i;

  done_testing;

=head1 METHODS

=over 4

=item * C<new(%args)>

  my $session = Brownie::Session->new(%args);

C<%args> are:

=over 8

=item * C<driver_name>: loadable driver name (e.g. 'Selenium', 'Mechanize', ...)

=item * C<driver_args>: some args to driver instantiation

=back

=back

=head2 Driver Delegation

=over 4

=item * C<visit($url)>

Go to $url.

  $session->visit('http://example.com/');

=item * C<current_url>

Returns current page's URL.

  my $url = $session->current_url;

=item * C<current_path>

Returns current page's path of URL.

  my $path = $session->current_path;

=item * C<title>

Returns current page's <title> text.

  my $title = $session->title;

=item * C<source>

Returns current page's HTML source.

  my $source = $session->source;

=item * C<screenshot($filename)>

Takes current page's screenshot and saves to $filename as PNG.

  $session->screenshot($filename);

=item * C<execute_script($javascript)>

Executes snippet of JavaScript into current page.

  $session->execute_script('$("body").empty()');

=item * C<evaluate_script($javascript)>

Executes snipptes and returns result.

  my $result = $session->evaluate_script('1 + 2');

If specified DOM element, it returns WebElement object.

  my $node = $session->evaluate_script('document.getElementById("foo")');

=back

=head2 Node Action

=over 4

=item * C<click_link($locator)>

Finds and clicks specified link.

  $session->click_link($locator);

C<$locator>: id or text of link

=item * C<click_button($locator)>

Finds and clicks specified buttons.

  $session->click_button($locator);

C<$locator>: id or value of button

=item * C<click_on($locator)>

Finds and clicks specified links or buttons.

  $session->click_on($locator);

It combines C<click_link> and C<click_button>.

=item * C<fill_in($locator, $value)>

Sets a value to located field (input or textarea).

  $session->fill_in($locator, $value);

=item * C<choose($locator)>

Selects a radio button.

  $session->choose($locator);

=item * C<check($locator)>

Sets a checkbox to "checked"

  $session->check($locator);

=item * C<uncheck($locator)>

Unsets a checkbox from "checked"

  $session->check($locator);

=item * C<select($locator)>

Selects an option.

  $session->select($locator);

=item * C<unselect($locator)>

Unselects an option in multiple select.

  $session->unselect($locator);

=item * C<attach_file($locator, $filename)>

Sets a path to file upload field.

  $session->attach_file($locator, $filename);

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Brownie::Driver>, L<Brownie::Node>

=cut
