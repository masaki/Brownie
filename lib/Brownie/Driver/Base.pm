package Brownie::Driver::Base;

use strict;
use warnings;
use Carp ();
use HTML::Selector::XPath ();

=head1 NAME

Brownie::Driver::Base - base class of Brownie::Driver series

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item * C<new( %args )>

=back

=cut

sub new {
    my ($class, %args) = @_;
    return bless { %args }, $class;
}

sub __not_implemented { Carp::croak('NOT IMPLEMENTED') }

sub _to_xpath {
    my ($self, $locator) = @_;
    # taken from Web::Scraper
    return $locator =~ m!^(?:/|id\()!
        ? $locator # XPath
        : HTML::Selector::XPath::selector_to_xpath($locator); # CSS to XPath
}

=head2 Browser

=over 4

=item * C<browser>

  my $browser = $driver->browser;

=back

=cut

*browser = \&__not_implemented;

=head2 Navigation

=over 4

=item * C<visit($url)>

Go to $url.

  $driver->visit('http://example.com/');

=item * C<current_url>

Returns current page's URL.

  my $url = $driver->current_url;

=item * C<current_path>

Returns current page's path of URL.

  my $path = $driver->current_path;

=back

=cut

*visit = \&__not_implemented;
*current_url = \&__not_implemented;
*current_path = \&__not_implemented;

=head2 Pages

=over 4

=item * C<title>

Returns current page's <title> text.

  my $title = $driver->title;

=item * C<source>

Returns current page's HTML source.

  my $source = $driver->source;

=item * C<screenshot($filename)>

Takes current page's screenshot and saves to $filename as PNG.

  $driver->screenshot($filename);

=back

=cut

*title = \&__not_implemented;
*source = \&__not_implemented;
*screenshot = \&__not_implemented;

=head2 Finder

=over 4

=item * C<find_element($locator)>

Find an element on the page, and return L<Brownie::Node> object.

  my $element = $driver->find_element($locator)

C<$locator> are:

  * CSS Selector

      my $element = $driver->find_element('#id');

  * XPath

      my $element = $driver->find_element('//a[1]');

=item * C<find_elements($locator)>

Find all elements on the page, and return L<Brownie::Node> object list.

  my @elements = $driver->find_elements($locator)

C<$locator> are:

  * CSS Selector

      my @elements = $driver->find_elements('a.navigation');

  * XPath

      my @elements = $driver->find_elements('//input[@type="text"]');

=back

=cut

sub find_element {
    my ($self, $locator) = @_;
    return shift @{[ $self->find_elements($locator) ]};
}

*find_elements = \&__not_implemented;

=head2 Links and Buttons

=over 4

=item * C<click_link($locator)>

Finds and clicks specified link.

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

=cut

*click_link = \&__not_implemented;
*click_button = \&__not_implemented;

sub click_on {
    my ($self, $locator) = @_;
    return $self->click_link($locator) || $self->click_button($locator);
}

=head2 Forms

=over 4

=item * C<fill_in($locator, -with => $value)>

=item * C<choose($locator)>

=item * C<check($locator)>

=item * C<uncheck($locator)>

=item * C<select($value, -from => $locator)>

=item * C<attach_file($locator, $filename)>

=back

=cut

*fill_in = \&__not_implemented;
*choose = \&__not_implemented;
*check = \&__not_implemented;
*uncheck = \&__not_implemented;
*select = \&__not_implemented;
*attach_file = \&__not_implemented;

=head2 Matchers

NOT YET

=head2 Scripting

=over 4

=item * C<execute_script($javascript)>

Executes snippet of JavaScript into current page.

  $driver->execute_script('$("body").empty()');

=item * C<evaluate_script($javascript)>

Executes snipptes and returns result.

  my $result = $driver->evaluate_script('1 + 2');

If specified DOM element, it returns WebElement object.

  my $node = $driver->evaluate_script('document.getElementById("foo")');

=back

=cut

*execute_script = \&__not_implemented;
*evaluate_script = \&__not_implemented;

=head1 SEE ALSO

L<Brownie::Driver::Selenium>, L<Brownie::Driver::Mechanize>

=cut

1;
