use inc::Module::Install;

name 'Brownie';
license 'perl';
all_from 'lib/Brownie.pm';

requires 'parent';
requires 'Carp';
requires 'Class::Load';
requires 'Sub::Install';
requires 'Scalar::Util' => 1.14;
requires 'URI';
requires 'HTML::Selector::XPath';
requires 'File::Slurp';
requires 'MIME::Base64';

requires 'WWW::Mechanize';
requires 'Selenium::Remote::Driver';

tests 't/*.t';
test_requires 'Test::More' => 0.98;
test_requires 'Test::UseAllModules';
test_requires 'Test::Data';
test_requires 'Test::Fake::HTTPD' => 0.03;
test_requires 'Test::Exception';
test_requires 'Test::File';
test_requires 'Exporter';
test_requires 'File::Temp';
test_requires 'File::Spec';
test_requires 'Data::Section::Simple';

recursive_author_tests 'xt';
auto_set_repository;
readme_pod_from 'lib/Brownie.pm';

WriteAll;
