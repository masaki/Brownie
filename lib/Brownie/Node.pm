package Brownie::Node;

use strict;
use warnings;
use Sub::Install;

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
    next if __PACKAGE__->can($_);
    Sub::Install::install_sub({
        code => Brownie->can('not_implemented'),
        as   => $_,
    });
}

1;
