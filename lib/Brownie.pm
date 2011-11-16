package Brownie;

use 5.008001;
use strict;
use warnings;
use Carp ();

our $VERSION = '0.04';

sub not_implemented { Carp::croak('Not implemented') }

1;

=head1 NAME

Brownie - Browser integration framework inspired by Capybara

=head1 SYNOPSIS

=head2 OO-Style

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

=head2 DSL-Style

NOT IMPLEMENTED YET

=head1 DESCRIPTION

Brownie is browser integrtion framework. It is inspired by Capybara (Ruby).

=head1 VOCABULARY

=over 4

=item * C<visit($url)>

=item * C<current_url>

=item * C<current_path>

=item * C<title>

=item * C<source>

=item * C<screenshot($filename)>

=item * C<click_link($locator)>

=item * C<click_button($locator)>

=item * C<click_on($locator)>

=item * C<fill_in($locator, $value)>

=item * C<choose($locator)>

=item * C<check($locator)>

=item * C<uncheck($locator)>

=item * C<select($locator)>

=item * C<unselect($locator)>

=item * C<attach_file($locator, $filename)>

=item * C<execute_script($javascript)>

=item * C<evaluate_script($javascript)>

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Brownie::Session>

L<Capybara|http://github.com/jnicklas/capybara>

L<Brownie::Driver::Selenium>, L<Brownie::Driver::Mechanize>

=cut
