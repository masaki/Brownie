package Brownie::Driver::Role::Forms;

use Any::Moose 'Role';

requires qw(
    fill_in
    choose
    check
    uncheck
    select
    attach_file
);

1;
