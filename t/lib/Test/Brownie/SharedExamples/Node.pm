package Test::Brownie::SharedExamples::Node;

use strict;
use warnings;
use parent 'Exporter';
use Test::More;

sub import { __PACKAGE__->export_to_level(2, @_) }

sub node_support_read_access {
    my $driver = shift;

    subtest 'should access to element information' => sub {
        my $element = $driver->find_element('h1');
        is $element->attr('id') => 'current_path';
        is $element->text => '/';
        is $element->tag_name => 'h1';
    };

    subtest 'should access to value of input element' => sub {
        my $element = $driver->find_element('#input_submit');
        is $element->value => 'Input Submit Value';
    };
}

sub node_support_inner_finder {
    my $driver = shift;

    my $parent = $driver->find_element('p#parent');

    subtest 'should get elements under specified element' => sub {
        my @children = $parent->find_elements('a');
        is scalar(@children) => 2;
        is $children[0]->text => 'child3';
        is $children[1]->text => 'child4';

        my @anchors = $driver->find_elements('a');
        cmp_ok scalar(@anchors), '>', scalar(@children);
    };

    subtest 'should get an element under specified element' => sub {
        my $child = $parent->find_element('a');
        is $child->text => 'child3';
    };
}

our @EXPORT;
{
    my $class = __PACKAGE__;
    no strict 'refs';
    for my $k (keys %{"${class}::"}) {
        next if $k =~ /^_/;
        next if $k =~ /^(?:BEGIN|CHECK|END|DESTROY)$/;
        next if $k =~ /^(?:import)$/;
        next unless *{"${class}::${k}"}{CODE};
        push @EXPORT, $k;
    }
}

1;
