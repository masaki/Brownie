package Brownie::Driver::Selenium;

use Any::Moose;
use Selenium::Remote::Driver;
use URI;
use File::Slurp 'write_file';
use MIME::Base64 'decode_base64';
use HTML::Selector::XPath 'selector_to_xpath';

with qw(
    Brownie::Driver::Role::Navigation
    Brownie::Driver::Role::Pages
    Brownie::Driver::Role::Clickable
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

visit, current_url, current_path

=cut

sub visit {
    my ($self, $url) = @_;
    browser->get($url);
}

sub current_url  { return URI->new(browser->get_current_url) }
sub current_path { return current_url->path }

=head2 Pages

title, source/body/html, screenshot

=cut

sub title { return browser->get_title }

sub source { return browser->get_page_source }
sub body   { return browser->get_page_source }
sub html   { return browser->get_page_source }

sub screenshot {
    my ($self, $file) = @_;
    my $image = decode_base64(browser->screenshot);
    write_file($file, { binmode => ':raw' }, $image);
}

=head2 Links and Buttons

click_link, click_button, click_on

=cut

sub _find_and_click {
    my ($self, $xpath) = @_;
    local $@;
    eval {
        my $element = browser->find_element($xpath);
        $element->click;
    };
    return $@ ? 0 : 1;
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
    );

    for my $xpath (@xpath) {
        return 1 if $self->_find_and_click($xpath);
    }
    return;
}

sub click_on {
}

=head2 Forms

fill_in, choose, check, uncheck, select, attach_file

=cut

=head2 Matchers

=cut

=head2 Finder

=cut

=head2 Scripting

execute_script

=cut

=head1 SEE ALSO

L<Selenium::Remote::Driver>

=cut

1;
