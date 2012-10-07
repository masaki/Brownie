package Brownie::XPath;

use strict;
use warnings;
use HTML::Selector::XPath ();

sub to_xpath {
    my $locator = shift;
    # taken from Web::Scraper
    return $locator =~ m!^(?:/|id\()!
        ? $locator # XPath
        : HTML::Selector::XPath::selector_to_xpath($locator); # CSS to XPath
}

sub to_link {
    my $locator = shift;
    return join '|', map { sprintf $_, $locator } (
        q!//a[@id='%s']!,
        q!//a[@name='%s']!,
        q!//a[@title='%s']!,
        q!//a[text()[contains(.,'%s')]]!,
        q!//a//img[@alt='%s']!,
    );
}

sub to_button {
    my $locator = shift;
    return join '|', map { sprintf $_, $locator } (
        q!//input[(@type='submit' or @type='button' or @type='image') and @id='%s']!,
        q!//input[(@type='submit' or @type='button' or @type='image') and @name='%s']!,
        q!//input[(@type='submit' or @type='button' or @type='image') and @title='%s']!,
        q!//input[(@type='submit' or @type='button' or @type='image') and @value='%s']!,
        q!//input[@type='image' and @alt='%s']!,
        q!//button[@id='%s']!,
        q!//button[@name='%s']!,
        q!//button[@title='%s']!,
        q!//button[@value='%s']!,
        q!//button[text()[contains(.,'%s')]]!,
    );
}

sub to_link_or_button {
    my $locator = shift;
    return join '|', map { sprintf $_, $locator } (
        q!//a[@id='%s']!,
        q!//a[@name='%s']!,
        q!//a[@title='%s']!,
        q!//a[text()[contains(.,'%s')]]!,
        q!//a//img[@alt='%s']!,
        q!//input[(@type='submit' or @type='button' or @type='image') and @id='%s']!,
        q!//input[(@type='submit' or @type='button' or @type='image') and @name='%s']!,
        q!//input[(@type='submit' or @type='button' or @type='image') and @title='%s']!,
        q!//input[(@type='submit' or @type='button' or @type='image') and @value='%s']!,
        q!//input[@type='image' and @alt='%s']!,
        q!//button[@id='%s']!,
        q!//button[@name='%s']!,
        q!//button[@title='%s']!,
        q!//button[@value='%s']!,
        q!//button[text()[contains(.,'%s')]]!,
    );
}

sub to_text_field {
    my $locator = shift;
    return join '|', map { sprintf $_, $locator } (
        q!//input[(@type='text' or @type='password' or @type='hidden' or not(@type)) and @id='%s']!,
        q!//input[(@type='text' or @type='password' or @type='hidden' or not(@type)) and @name='%s']!,
        q!//input[(@type='text' or @type='password' or @type='hidden' or not(@type)) and @title='%s']!,
        q!//input[(@type='text' or @type='password' or @type='hidden' or not(@type)) and @value='%s']!,
        q!//input[(@type='text' or @type='password' or @type='hidden' or not(@type)) and @id=//label[text()[contains(.,'%s')]]/@for]!,
        q!//label[text()[contains(.,'%s')]]//input[(@type='text' or @type='password' or @type='hidden' or not(@type))]!,
        q!//textarea[@id='%s']!,
        q!//textarea[@name='%s']!,
        q!//textarea[@title='%s']!,
        q!//textarea[@id=//label[text()[contains(.,'%s')]]/@for]!,
        q!//label[text()[contains(.,'%s')]]//textarea!,
    );
}

sub to_radio {
    my $locator = shift;
    return join '|', map { sprintf $_, $locator } (
        q!//input[@type='radio' and @id='%s']!,
        q!//input[@type='radio' and @name='%s']!,
        q!//input[@type='radio' and @title='%s']!,
        q!//input[@type='radio' and @value='%s']!,
        q!//input[@type='radio' and @id=//label[text()[contains(.,'%s')]]/@for]!,
        q!//label[text()[contains(.,'%s')]]//input[@type='radio']!,
    );
}

sub to_checkbox {
    my $locator = shift;
    return join '|', map { sprintf $_, $locator } (
        q!//input[@type='checkbox' and @id='%s']!,
        q!//input[@type='checkbox' and @name='%s']!,
        q!//input[@type='checkbox' and @title='%s']!,
        q!//input[@type='checkbox' and @value='%s']!,
        q!//input[@type='checkbox' and @id=//label[text()[contains(.,'%s')]]/@for]!,
        q!//label[text()[contains(.,'%s')]]//input[@type='checkbox']!,
    );
}

sub to_option {
    my $locator = shift;
    return join '|', map { sprintf $_, $locator } (
        q!//option[@id='%s']!,
        q!//option[@name='%s']!,
        q!//option[@title='%s']!,
        q!//option[@value='%s']!,
        q!//option[text()[contains(.,'%s')]]!,
    );
}

sub to_file_field {
    my $locator = shift;
    return join '|', map { sprintf $_, $locator } (
        q!//input[@type='file' and @id='%s']!,
        q!//input[@type='file' and @name='%s']!,
        q!//input[@type='file' and @title='%s']!,
        q!//input[@type='file' and @id=//label[text()[contains(.,'%s')]]/@for]!,
        q!//label[text()[contains(.,'%s')]]//input[@type='file']!,
    );
}

1;

=head1 NAME

Brownie::XPath

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Brownie::Session>

=cut
