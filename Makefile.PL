use inc::Module::Install;
use Module::Install::AuthorTests;
use Module::Install::Repository;
use Module::Install::ReadmePodFromPod;
use Module::Install::Any::Moose;

name 'Brownie';
license 'perl';
all_from 'lib/Brownie.pm';

requires_any_moose prefer => 'Mouse';

requires 'URI';
requires 'HTML::Selector::XPath';
requires 'File::Slurp';
requires 'MIME::Base64';

#requires 'WWW::Mechanize';
requires 'Selenium::Remote::Driver';

tests 't/*.t';
test_requires 'Test::More' => 0.98;
test_requires 'Test::UseAllModules';
test_requires 'Test::Flatten';
test_requires 'Test::Fake::HTTPD';
test_requires 'Test::Exception';
test_requires 'Test::File';
test_requires 'File::Temp';

recursive_author_tests 'xt';
auto_set_repository;
readme_pod_from 'lib/Brownie.pm';

WriteAll;
