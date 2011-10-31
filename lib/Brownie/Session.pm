package Brownie::Session;

use strict;
use warnings;
use Class::Load;
use Sub::Install;
use Class::Method::Modifiers;

use Brownie::Driver;
use Brownie::Node;

sub new {
    my ($class, %args) = @_;

    $args{driver_name}  ||= 'Selenium';
    $args{driver_class} ||= 'Brownie::Driver::' . $args{driver_name};
    $args{driver_args}  ||= {};

    Class::Load::load_class($args{driver_class});
    my $driver = $args{driver_class}->new(%{$args{driver_args}});

    return bless { %args, scopes => [], driver => $driver }, $class;
}

sub DESTROY {
    my $self = shift;
    delete $self->{driver};
}

sub driver { shift->{driver} }
for my $method (Brownie::Driver->PROVIDED_METHODS) {
    Sub::Install::install_sub({
        code => sub { shift->driver->$method(@_) },
        as   => $method,
    });
}

sub current_node { shift->{scopes}->[-1] }

after 'visit' => sub {
    my $self = shift;
    # clear scopes
    $self->{scopes} = [ $self->document ];
};

1;

=head1 NAME

Brownie::Session - browser session class

=cut
