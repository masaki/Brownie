use Test::More;
use Test::Brownie;
use Brownie::Driver::Selenium;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd;

describe 'Brownie::Driver::Selenium [Scripting]' => sub {
    driver_support_script($driver, $httpd);
};

done_testing;
