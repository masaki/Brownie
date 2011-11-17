package Brownie::Driver::Selenium;

use strict;
use warnings;
use parent 'Brownie::Driver';
use Selenium::Remote::Driver;
use Scalar::Util qw(blessed);
use URI;
use File::Slurp qw(write_file);
use MIME::Base64 qw(decode_base64);

use Brownie::XPath;
use Brownie::Node::Selenium;

(our $NodeClass = __PACKAGE__) =~ s/Driver/Node/;

sub new {
    my ($class, %args) = @_;

    $args{selenium_host}    ||= ($ENV{SELENIUM_HOST}    || '127.0.0.1');
    $args{selenium_port}    ||= ($ENV{SELENIUM_PORT}    || 4444);
    $args{selenium_browser} ||= ($ENV{SELENIUM_BROWSER} || 'firefox');

    return $class->SUPER::new(%args);
}

sub DESTROY {
    my $self = shift;
    delete $self->{browser};
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

sub find_element {
    my ($self, $locator, %args) = @_;

    my $element;
    my $xpath = Brownie::XPath::to_xpath($locator);

    if (my $base = $args{-base}) {
        my $node = (blessed($base) and $base->can('native')) ? $base->native : $base;
        $element = eval { $self->browser->find_child_element($node, ".$xpath") }; # abs2rel
    }
    else {
        $element = eval { $self->browser->find_element($xpath) };
    }

    return $element ? $NodeClass->new(driver => $self, native => $element) : undef;
}

sub find_elements {
    my ($self, $locator, %args) = @_;

    my @elements = ();
    my $xpath = Brownie::XPath::to_xpath($locator);

    if (my $base = $args{-base}) {
        my $node = (blessed($base) and $base->can('native')) ? $base->native : $base;
        @elements = eval { $self->browser->find_child_elements($node, ".$xpath") }; # abs2rel
    }
    else {
        @elements = eval { $self->browser->find_elements($xpath) };
    }

    return @elements ? map { $NodeClass->new(driver => $self, native => $_) } @elements : ();
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

Please see L<Brownie::Driver> document.

=head1 METHODS

=head2 IMPLEMENTED

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

=item * C<browser>

=item * C<visit($url)>

=item * C<current_url>

=item * C<current_path>

=item * C<title>

=item * C<source>

=item * C<screenshot($filename)>

=item * C<execute_script($javascript)>

=item * C<evaluate_script($javascript)>

=item * C<find_element($locator)>

=item * C<find_elements($locator)>

=back

=head2 OVERRIDED

=over 4

=item * C<document>

=back

=head2 NOT SUPPORTED

=over 4

=item * C<status_code>

=item * C<response_headers>

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
