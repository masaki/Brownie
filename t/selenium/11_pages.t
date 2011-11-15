use Test::More;
use Test::Brownie;
use Brownie::Driver::Selenium;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd;

describe 'Brownie::Driver::Selenium [Pages]' => sub {
    $driver->visit($httpd->endpoint);

    driver_can_read_contents($driver);
    driver_can_take_screenshot($driver);
};

done_testing;
