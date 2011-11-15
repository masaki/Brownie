use Test::More;
use Test::Brownie;
use Brownie::Driver::Selenium;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd;

describe 'Brownie::Driver::Selenium [Finder]' => sub {
    $driver->visit($httpd->endpoint);

    driver_can_find_elements_with_xpath($driver);
    driver_can_find_elements_with_selector($driver);
};

done_testing;
