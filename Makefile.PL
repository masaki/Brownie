use inc::Module::Install;
use Module::Install::AuthorTests;
use Module::Install::Repository;
use Module::Install::ReadmePodFromPod;

name 'Brownie';
license 'perl';
all_from 'lib/Brownie.pm';

# requires '';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'Test::UseAllModules';

recursive_author_tests 'xt';
auto_set_repository;
readme_pod_from 'lib/Brownie.pm';

WriteAll;
