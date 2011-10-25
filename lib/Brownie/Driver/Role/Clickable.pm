package Brownie::Driver::Role::Clickable;

use Any::Moose 'Role';

requires qw(
    click_link
    click_button
    click_on
);

1;
