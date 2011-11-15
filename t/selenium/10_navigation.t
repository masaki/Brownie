use Test::More;
use Test::Brownie;
use Brownie::Driver::Selenium;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd;

describe 'Brownie::Driver::Selenium [Navigation]' => sub {
    driver_can_open_page($driver, $httpd);
};

done_testing;
