package Brownie::Driver::Role::Navigation;

use Any::Moose 'Role';

requires qw(
    visit
    current_url
    current_path
);

1;
