package Brownie::Driver::Selenium;

use Any::Moose;
use Selenium::Remote::Driver;
use URI;
use File::Slurp 'write_file';
use MIME::Base64 'decode_base64';

with qw(
    Brownie::Driver::Role::Navigation
    Brownie::Driver::Role::Pages
);

our $Browser;
sub browser {
    $Browser ||= Selenium::Remote::Driver->new(
        remote_server_addr => $ENV{SELENIUM_HOST} || $ENV{SELENIUM_ADDR} || 'localhost',
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

=cut

sub visit {
    my ($self, $url) = @_;
    browser->get($url);
}

sub current_url {
    return URI->new(browser->get_current_url);
}

sub current_path {
    return current_url->path;
}

=head2 Pages

=cut

sub title {
    return browser->get_title;
}

sub source {
    return browser->get_page_source;
}
*body = \&source;

sub screenshot {
    my ($self, $file) = @_;
    my $image = decode_base64(browser->screenshot);
    write_file($file, { binmode => ':raw' }, $image);
}

=head2 Links and Buttons

=cut

=head2 Forms

=cut

=head2 Matchers

=cut

=head2 Finder

=cut

=head2 Scripting

=cut

1;
