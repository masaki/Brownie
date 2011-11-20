package Brownie::Driver::Mechanize;

use strict;
use warnings;
use parent 'Brownie::Driver';
use WWW::Mechanize;
use HTML::TreeBuilder::XPath;
use constant HAS_LIBXML => eval { require HTML::TreeBuilder::LibXML; 1 };
use Scalar::Util qw(blessed);

use Brownie;
use Brownie::XPath;
use Brownie::Node::Mechanize;

(our $NodeClass = __PACKAGE__) =~ s/Driver/Node/;

sub DESTROY {
    my $self = shift;
    delete $self->{browser};
}

sub browser {
    my $self = shift;

    $self->{browser} ||= WWW::Mechanize->new(
        agent       => "Brownie/${Brownie::VERSION}",
        cookie_jar  => +{},
        quiet       => 1,
        stack_depth => 1,
    );

    return $self->{browser};
}

sub visit {
    my ($self, $url) = @_;
    $self->browser->get("$url"); # stringify for URI
}

sub current_url {
    my $self = shift;
    return $self->browser->uri->clone;
}

sub current_path {
    my $self = shift;
    return $self->current_url->path;
}

sub status_code {
    my $self = shift;
    return $self->browser->status;
}

sub response_headers {
    my $self = shift;
    return $self->browser->res->headers;
}

sub title {
    my $self = shift;
    return $self->browser->title;
}

sub source {
    my $self = shift;
    my $content = $self->browser->content;
    # TODO: consider gzip and deflate
    return $content;
}

sub _root {
    my $self = shift;
    my $builder = HAS_LIBXML ? 'HTML::TreeBuilder::LibXML' : 'HTML::TreeBuilder::XPath';
    my $tree = $builder->new_from_content($self->source);
}

sub find_element {
    my ($self, $locator, %args) = @_;

    my @elements = $self->find_elements($locator, %args);
    return @elements ? shift(@elements) : undef;
}

sub find_elements {
    my ($self, $locator, %args) = @_;

    my @elements = ();
    my $xpath = Brownie::XPath::to_xpath($locator);

    if (my $base = $args{-base}) {
        my $node = (blessed($base) and $base->can('native')) ? $base->native : $base;
        $xpath = ".$xpath" unless $xpath =~ /^\./;
        @elements = $node->findnodes($xpath); # abs2rel
    }
    else {
        @elements = $self->_root->findnodes($xpath);
    }

    return @elements ? map { $NodeClass->new(driver => $self, native => $_) } @elements : ();
}

1;

=head1 NAME

Brownie::Driver::Mechanize - WWW::Mechanize bridge implementation

=head1 DESCRIPTION

Please see L<Brownie::Driver> document.

=head1 METHODS

=head2 IMPLEMENTED

=over 4

=item * C<browser>

=item * C<visit($url)>

=item * C<current_url>

=item * C<current_path>

=item * C<status_code>

=item * C<response_headers>

=item * C<title>

=item * C<source>

=item * C<find_element($locator)>

=item * C<find_elements($locator)>

=back

=head2 OVERRIDED

=over 4

=item * C<new>

=item * C<document>

=back

=head2 NOT SUPPORTED

=over 4

=item * C<screenshot($filename)>

=item * C<execute_script($javascript)>

=item * C<evaluate_script($javascript)>

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Brownie::Driver>, L<Brownie::Node>, L<Brownie::Node::Mechanize>

L<WWW::Mechanize>

=cut
