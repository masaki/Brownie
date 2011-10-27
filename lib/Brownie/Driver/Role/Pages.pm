package Brownie::Driver::Role::Pages;

use Any::Moose 'Role';

requires qw(
    title
    source
    screenshot
);

1;
