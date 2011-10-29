package Brownie::Node::Base;

use strict;
use warnings;

use Brownie;

sub new {
    my ($class, %args) = @_;
    return bless { %args }, $class;
}

sub driver { shift->{driver} }
sub native { shift->{native} }

our @Getter = qw(attr value text tag_name);
our @Setter = qw(set select unselect);
our @Action = qw(click);
our @Query  = qw(is_displayed is_selected is_checked);

our @Method = (@Getter, @Setter, @Action, @Query);
for (@Method) {
    no strict 'refs';
    *{$_} = \&Brownie::not_implemented;
}

1;
