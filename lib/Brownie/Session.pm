package Brownie::Session;

use strict;
use warnings;
use Class::Load;
use Sub::Install;

use Brownie::Driver;
use Brownie::Node;

sub new {
    my ($class, %args) = @_;

    $args{driver_name}  ||= 'Selenium';
    $args{driver_class} ||= 'Brownie::Driver::' . $args{driver_name};
    $args{driver_args}  ||= {};

    Class::Load::load_class($args{driver_class});
    my $driver = $args{driver_class}->new(%${args{driver_args}});

    return bless { %args, driver => $driver }, $class;
}

sub DESTROY {
    my $self = shift;
    delete $self->{driver};
}

sub driver { shift->{driver} }
for my $method (Brownie::Driver->PROVIDED_METHODS) {
    Sub::Install::install_sub({
        code => sub { shift->driver->$method(@_) },
        as   => $_,
    });
}


1;

=head1 NAME

Brownie::Session - browser session class

=cut
