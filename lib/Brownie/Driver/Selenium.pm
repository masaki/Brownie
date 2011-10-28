package Brownie::Driver::Selenium;

use strict;
use warnings;
use parent 'Brownie::Driver::Base';
use Selenium::Remote::Driver;
use URI;
use File::Slurp 'write_file';
use MIME::Base64 'decode_base64';
use HTML::Selector::XPath 'selector_to_xpath';

=head1 NAME

Brownie::Driver::Selenium

=head1 METHODS

=head2 Browser

=over 4

=item * C<browser>

  my $browser = $driver->browser;

You can set selenium-server parameters using C<%ENV>:

  * SELENIUM_HOST:    selenium server host or address (default: 127.0.0.1)
  * SELENIUM_PORT:    selenium server port            (default: 4444)
  * SELENIUM_BROWSER: selenium server browser name    (default: "firefox")

=back

=cut

our $Browser;
sub browser {
    $Browser ||= Selenium::Remote::Driver->new(
        remote_server_addr => $ENV{SELENIUM_HOST} || $ENV{SELENIUM_ADDR} || '127.0.0.1',
        port               => $ENV{SELENIUM_PORT} || 4444,
        browser_name       => $ENV{SELENIUM_BROWSER} || 'firefox',
    );
    return $Browser;
}

END {
    if ($Browser) {
        $Browser->quit;
        undef $Browser;
    }
}

=head2 Navigation

=over 4

=item * C<visit($url)>

Go to $url.

  $driver->visit('http://example.com/');

=cut

sub visit {
    my ($self, $url) = @_;
    $self->browser->get($url);
}

=item * C<current_url>

Returns current page's URL.

  my $url = $driver->current_url;

=cut

sub current_url {
    my $self = shift;
    return URI->new($self->browser->get_current_url);
}

=item * C<current_path>

Returns current page's path of URL.

  my $path = $driver->current_path;

=back

=cut

sub current_path {
    my $self = shift;
    return $self->current_url->path;
}

=head2 Pages

=over 4

=item * C<title>

Returns current page's <title> text.

  my $title = $driver->title;

=cut

sub title {
    my $self = shift;
    return $self->browser->get_title;
}

=item * C<source>

Returns current page's HTML source.

  my $source = $driver->source;

=cut

sub source {
    my $self = shift;
    return $self->browser->get_page_source;
}

=item * C<screenshot($filename)>

Takes current page's screenshot and saves to $filename as PNG.

  $driver->screenshot($filename);

=back

=cut

sub screenshot {
    my ($self, $file) = @_;
    my $image = decode_base64($self->browser->screenshot);
    write_file($file, { binmode => ':raw' }, $image);
}

=head2 Links and Buttons

=over 4

=item * C<click_link($locator)>

Finds and clicks specified links.

  $driver->click_link($locator);

C<$locator> are:

=over 8

=item * C<#id>

=item * C<//xpath>

=item * C<text() of E<lt>aE<gt>>

(e.g.) <a href="...">{locator}</a>

=item * C<@title of E<lt>aE<gt>>

(e.g.) <a title="{locator}">...</a>

=item * C<child E<lt>imgE<gt> @alt>

(e.g.) <a><img alt="{locator}"/></a>

=back

=cut

sub click_link {
    my ($self, $locator) = @_;

    my @xpath;
    # taken from Web::Scraper
    push @xpath, ($locator =~ m!^(?:/|id\()! ? $locator : selector_to_xpath($locator));
    push @xpath, (
        "//a[text()='$locator']",
        "//a[\@title='$locator']",
        "//a//img[\@alt='$locator']"
    );

    for my $xpath (@xpath) {
        return 1 if $self->_find_and_click($xpath);
    }
    return;
}

=item * C<click_button($locator)>

Finds and clicks specified buttons.

  $driver->click_button($locator);

C<$locator> are:

=over 8

=item * C<#id>

=item * C<//xpath>

=item * C<@value of E<lt>inputE<gt> / E<lt>buttonE<gt>>

(e.g.) <input value="{locator}"/>

=item * C<@title of E<lt>inputE<gt> / E<lt>buttonE<gt>>

(e.g.) <button title="{locator}">...</button>

=item * C<text() of E<lt>buttonE<gt>>

(e.g.) <button>{locator}</button>

=item * C<@alt of E<lt>input type="image"E<gt>>

(e.g.) <input type="image" alt="{locator}"/>

=back

=cut

sub click_button {
    my ($self, $locator) = @_;

    my @xpath;
    # taken from Web::Scraper
    push @xpath, ($locator =~ m!^(?:/|id\()! ? $locator : selector_to_xpath($locator));
    my $types = q/(@type='submit' or @type='button' or @type='image')/;
    push @xpath, (
        "//input[$types and \@value='$locator']",
        "//input[$types and \@title='$locator']",
        "//button[\@value='$locator']",
        "//button[\@title='$locator']",
        "//button[text()='$locator']",
        "//input[\@type='image' and \@alt='$locator']",
    );

    for my $xpath (@xpath) {
        return 1 if $self->_find_and_click($xpath);
    }
    return;
}

=item * C<click_on($locator)>

Finds and clicks specified links or buttons.

  $driver->click_on($locator);

It combines C<click_link> and C<click_button>.

=back

=cut

sub click_on {
    my ($self, $locator) = @_;
    return $self->click_link($locator) || $self->click_button($locator);
}

sub _find_and_click {
    my ($self, $xpath) = @_;
    local $@;
    eval {
        my $element = $self->browser->find_element($xpath);
        $element->click;
    };
    return $@ ? 0 : 1;
}

=head2 Forms

=over 4

=item * C<fill_in>

=cut

=item * C<choose>

=cut

=item * C<check>

=cut

=item * C<uncheck>

=cut

=item * C<select>

=cut

=item * C<attach_file>

=back

=cut

=head2 Matchers

NOT YET

=head2 Finder

NOT YET

=head2 Scripting

=over 4

=item * C<execute_script>

=back

=cut

=head1 SEE ALSO

L<Selenium::Remote::Driver>

=cut

1;
