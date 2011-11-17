use Test::More;
use Test::Brownie;
use Brownie::Driver::Selenium;
use Brownie::Node::Selenium;

describe 'Brownie::Driver::Selenium' => sub {
    my $driver = Brownie::Driver::Selenium->new;
    my $httpd = test_httpd;

    context 'Browser' => sub {
        ok $driver->browser;
        isa_ok $driver->browser => 'Selenium::Remote::Driver';
    };

    context 'Navigation' => sub {
        driver_support_navigation($driver, $httpd);
    };

    context 'Headers' => sub {
        $driver->visit($httpd->endpoint);
        driver_not_support_status_code($driver);
        driver_not_support_header_access($driver);
    };

    context 'Pages' => sub {
        $driver->visit($httpd->endpoint);
        driver_support_html_parse($driver);
        driver_support_screenshot($driver);
    };

    context 'Scripting' => sub {
        $driver->visit($httpd->endpoint);
        driver_support_script($driver);
    };

    context 'Finder' => sub {
        $driver->visit($httpd->endpoint);
        driver_support_xpath_finder($driver);
        driver_support_css_selector_finder($driver);
    };
};

describe 'Brownie::Node::Selenium' => sub {
    my $driver = Brownie::Driver::Selenium->new;
    my $httpd = test_httpd;

    context 'Accessor' => sub {
        $driver->visit($httpd->endpoint);
        node_support_read_access($driver);
    };

    context 'Finder' => sub {
        $driver->visit($httpd->endpoint);
        node_support_inner_finder($driver);
    };

    context 'State' => sub {
        $driver->visit($httpd->endpoint);
        node_support_visibility_check($driver);
        node_support_form_control_check($driver);
    };

    context 'Action' => sub {
        $driver->visit($httpd->endpoint);
        node_support_text_action($driver);
        node_support_click_action($driver);
        node_support_checkbox_action($driver);
        node_support_radio_action($driver);
        node_support_select_action($driver);
    };
};

done_testing;
