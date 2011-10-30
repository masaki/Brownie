package Brownie::Driver::Selenium;

use strict;
use warnings;
use parent 'Brownie::Driver';
use Selenium::Remote::Driver;
use Scalar::Util qw(blessed);
use URI;
use File::Slurp qw(write_file);
use MIME::Base64 qw(decode_base64);

use Brownie;
use Brownie::Node::Selenium;

sub new {
    my ($class, %args) = @_;

    $args{selenium_host}    ||= ($ENV{SELENIUM_HOST}    || '127.0.0.1');
    $args{selenium_port}    ||= ($ENV{SELENIUM_PORT}    || 4444);
    $args{selenium_browser} ||= ($ENV{SELENIUM_BROWSER} || 'firefox');

    return $class->SUPER::new(%args);
}

sub DESTROY {
    my $self = shift;

    if ($self->{browser}) {
        $self->{browser}->quit;
        undef $self->{browser};
    }
}

### Browser

sub browser {
    my $self = shift;

    $self->{browser} ||= Selenium::Remote::Driver->new(
        remote_server_addr => $self->{selenium_host},
        port               => $self->{selenium_port},
        browser_name       => $self->{selenium_browser},
    );

    return $self->{browser};
}

### Navigation

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

### Pages

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

### Finder

sub find_elements {
    my ($self, $locator, %args) = @_;

    my @elements = ();
    my $xpath = Brownie::to_xpath($locator);

    if (my $base = $args{-base}) {
        my $node = (blessed($base) and $base->can('native')) ? $base->native : $base;
        @elements = eval { $self->browser->find_child_elements($node, $xpath) };
    }
    else {
        @elements = eval { $self->browser->find_elements($xpath) };
    }

    return map {
        Brownie::Node::Selenium->new(driver => $self, native => $_);
    } @elements;
}

### Links and Buttons

sub click_link {
    my ($self, $locator) = @_;

    my @xpath = (
        Brownie::to_xpath($locator),
        "//a[text()='$locator']",
        "//a[\@title='$locator']",
        "//a//img[\@alt='$locator']",
    );

    return $self->_click(@xpath);
}

sub click_button {
    my ($self, $locator) = @_;

    my $types = q/(@type='submit' or @type='button' or @type='image')/;
    my @xpath = (
        Brownie::to_xpath($locator),
        "//input[$types and \@value='$locator']",
        "//input[$types and \@title='$locator']",
        "//button[\@value='$locator']",
        "//button[\@title='$locator']",
        "//button[text()='$locator']",
        "//input[\@type='image' and \@alt='$locator']",
    );

    return $self->_click(@xpath);
}

sub _click {
    my ($self, @xpath) = @_;

    for my $xpath (@xpath) {
        if (my $element = $self->find_element($xpath)) {
            $element->click;
            return 1;
        }
    }

    return 0;
}

### Forms

sub fill_in {
    my ($self, $locator, %args) = @_;
}

sub choose {
    my ($self, $locator) = @_;
}

sub check {
    my ($self, $locator) = @_;
}

sub uncheck {
    my ($self, $locator) = @_;
}

sub select {
    my ($self, $value, %args) = @_;
}

sub attach_file {
    my ($self, $locator, $file) = @_;
}

### Scripting

sub execute_script {
    my ($self, $script) = @_;
    $self->browser->execute_script($script);
}

sub evaluate_script {
    my ($self, $script) = @_;
    return $self->browser->execute_script("return $script");
}

1;

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

  * SELENIUM_HOST
  * SELENIUM_PORT
  * SELENIUM_BROWSER

=back

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

=head2 Finder

=over 4

=item * C<find_element($locator)>

=item * C<find_elements($locator)>

=back

=head2 Links and Buttons

=over 4

=item * C<click_link($locator)>

=item * C<click_button($locator)>

=item * C<click_on($locator)>

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

=head2 Scripting

=over 4

=item * C<execute_script($javascript)>

=item * C<evaluate_script($javascript)>

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Brownie::Driver>, L<Brownie::Node>, L<Brownie::Node::Selenium>

L<Selenium::Remote::Driver>

=cut
