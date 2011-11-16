use Test::More;
use Test::Brownie;
use Brownie::Driver::Selenium;

describe 'Brownie::Driver::Selenium' => sub {
    my $driver = Brownie::Driver::Selenium->new;
    my $httpd = test_httpd;

    context 'Browser' => sub {
        it 'should returns Selenium::Remote::Driver object' => sub {
            ok my $browser = $driver->browser;
            isa_ok $browser => 'Selenium::Remote::Driver';
        };

        it 'should have browser object' => sub {
            ok $driver->{browser};
            isa_ok $driver->{browser} => 'Selenium::Remote::Driver';
        };
    };

    context 'Navigation' => sub {
        driver_support_navigation($driver, $httpd);
    };

    context 'HTTP' => sub {
        driver_not_support_status_code($driver);
        driver_not_support_header_access($driver);
    };

    context 'Pages' => sub {
        driver_support_html_parse($driver);
        driver_support_screenshot($driver);
    };

    context 'Scripting' => sub {
        driver_support_script($driver);
    };

    context 'Finder' => sub {
        driver_support_xpath_finder($driver);
        driver_support_css_selector_finder($driver);
    };
};

done_testing;
