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

Brownie::Driver::Selenium - Selenium WebDriver bridge implementation

=head1 DESCRIPTION

Please see L<Brownie::Driver::Base> document.

=head1 METHODS

=over 4

=item * C<new( %args )>

  my $driver = Brownie::Driver::Selenium->new(%args);

C<%args> are:

  * selenium_host:    selenium server host or address (default: 127.0.0.1)
  * selenium_port:    selenium server port            (default: 4444)
  * selenium_browser: selenium server browser name    (default: "firefox")

You can also set selenium-server parameters using C<%ENV>:

  * SELENIUM_HOST:    selenium server host or address (default: 127.0.0.1)
  * SELENIUM_PORT:    selenium server port            (default: 4444)
  * SELENIUM_BROWSER: selenium server browser name    (default: "firefox")

=back

=cut

sub new {
    my ($class, %args) = @_;

    $args{selenium_host}    ||= ($ENV{SELENIUM_HOST}    || '127.0.0.1');
    $args{selenium_port}    ||= ($ENV{SELENIUM_PORT}    || 4444);
    $args{selenium_browser} ||= ($ENV{SELENIUM_BROWSER} || 'firefox');

    return $class->SUPER::new(%args);
}

=head2 Browser

=over 4

=item * C<browser>

=back

=head2 Navigation

=over 4

=item * C<visit($url)>

=item * C<current_url>

=item * C<current_path>

=back

=head2 Pages

=over 4

=item * C<title>

=item * C<source>

=item * C<screenshot($filename)>

=back

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

=item * C<click_on($locator)>

Finds and clicks specified links or buttons.

  $driver->click_on($locator);

It combines C<click_link> and C<click_button>.

=back

=head2 Forms

=over 4

=item * C<fill_in($locator, -with => $value)>

=item * C<choose($locator)>

=item * C<check($locator)>

=item * C<uncheck($locator)>

=item * C<select($value, -from => $locator)>

=item * C<attach_file($locator, $filename)>

=back

=head2 Matchers

NOT YET

=head2 Finder

NOT YET

=head2 Scripting

=over 4

=item * C<execute_script($javascript)>

=item * C<evaluate_script($javascript)>

=back

=cut

sub browser {
    my $self = shift;

    $self->{browser} ||= Selenium::Remote::Driver->new(
        remote_server_addr => $self->{selenium_host},
        port               => $self->{selenium_port},
        browser_name       => $self->{selenium_browser},
    );

    return $self->{browser};
}

sub DESTROY {
    my $self = shift;

    if ($self->{browser}) {
        $self->{browser}->quit;
        undef $self->{browser};
    }
}

sub visit {
    my ($self, $url) = @_;
    $self->browser->get("$url"); # stringify for URI
}

sub current_url {
    my $self = shift;
    return URI->new($self->browser->get_current_url);
}

sub current_path {
    my $self = shift;
    return $self->current_url->path;
}

sub title {
    my $self = shift;
    return $self->browser->get_title;
}

sub source {
    my $self = shift;
    return $self->browser->get_page_source;
}

sub screenshot {
    my ($self, $file) = @_;
    my $image = decode_base64($self->browser->screenshot);
    write_file($file, { binmode => ':raw' }, $image);
}

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

sub fill_in {
}

sub choose {
}

sub check {
}

sub uncheck {
}

sub select {
}

sub attach_file {
}

sub execute_script {
    my ($self, $script) = @_;
    $self->browser->execute_script($script);
}

sub evaluate_script {
    my ($self, $script) = @_;
    # TODO: Brownie::Node-ify
    return $self->browser->execute_script("return $script");
}

=head1 SEE ALSO

L<Selenium::Remote::Driver>

=cut

1;
