package Brownie::DSL;

use strict;
use warnings;
use Sub::Install;
use Brownie;

our @DriverMethods = qw(
    current_url
    current_path
    status_code
    response_headers
    title
    source
    screenshot
    execute_script
    evaluate_script
    body
    visit
    current_node
    document
    find
    first
    all
    click_link
    click_button
    click_link_or_button
    fill_in
    choose
    check
    uncheck
    select
    unselect
    attach_file
);
our @SessionMethods = qw(
    page
);
our @DslMethods = (@DriverMethods, @SessionMethods);

sub page { Brownie->current_session }

sub import {
    my $class  = shift;
    my $caller = caller;

    for my $method (@DriverMethods) {
        Sub::Install::install_sub({
          code => sub { page->$method(@_) },
          into => $caller,
          as   => $method,
        });
    }
    for my $method (@SessionMethods) {
        Sub::Install::install_sub({
          code => \&$method,
          into => $caller,
          as   => $method,
        });
    }
}

1;

=head1 NAME

Brownie::DSL - provides DSL-Style interface to use browser session

=head1 SYNOPSIS

  use Brownie::DSL;

  # external server
  Brownie->driver('Mechanize');
  Brownie->app_host('http://app.example.com:5000');

  # PSGI app
  Brownie->driver('Mechanize');
  Brownie->app(sub { ...(PSGI app)... });

  # psgi file
  Brownie->driver('Mechanize');
  Brownie->app('app.psgi');

  visit('/');
  is title, 'Some Title';

  fill_in('User Name' => 'brownie');
  fill_in('Email Address' => 'brownie@example.com');
  click_button('Login');
  like source, qr/Welcome (.+)/;

  fill_in(q => 'Brownie');
  lick_link_or_button('Search');
  like title, qr/Search result of Brownie/i;

  done_testing;

=head1 CLASS METHODS

=over 4

=item * C<driver>: loadable driver name or config

=item * C<app_host>: external target application

=item * C<app>: PSGI application

=back

=head1 FUNCTIONS

=over 4

=item * C<page>

Shortcut to accessing the current session.

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

=item * C<find($locator)>

=item * C<all($locator)>

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Brownie::Session>

=cut
