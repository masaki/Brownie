package Brownie::XPath;

use strict;
use warnings;
use HTML::Selector::XPath qw(selector_to_xpath);

sub to_link {
    my $locator = shift;
    return map { sprintf $_, $locator } qw(
        //a[@id="%s"]
        //a[text()="%s"]
        //a[@title="%s"]
        //a//img[@alt="%s"]
    );
}

sub to_button {
    my $locator = shift;
    return map { sprintf $_, $locator } (
        q!//input[(@type="submit" or @type="button" or @type="image") and @id="%s"]!,
        q!//input[(@type="submit" or @type="button" or @type="image") and @value="%s"]!,
        q!//input[(@type="submit" or @type="button" or @type="image") and @title="%s"]!,
        q!//input[@type="image" and @alt="%s"]!,
        q!//button[@id="%s"]!,
        q!//button[@value="%s"]!,
        q!//button[@title="%s"]!,
        q!//button[text()="%s"]!,
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
