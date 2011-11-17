use Test::More;
use Test::Brownie;
use Brownie::Driver::Mechanize;
use Brownie::Node::Mechanize;

describe 'Brownie::Driver::Mechanize' => sub {
    my $driver = Brownie::Driver::Mechanize->new;
    my $httpd = test_httpd;

    context 'Browser' => sub {
        ok $driver->browser;
        isa_ok $driver->browser => 'WWW::Mechanize';
    };

    context 'Navigation' => sub {
        driver_support_navigation($driver, $httpd);
    };

    context 'Headers' => sub {
        $driver->visit($httpd->endpoint);
        driver_support_status_code($driver);
        driver_support_header_access($driver);
    };

    context 'Pages' => sub {
        $driver->visit($httpd->endpoint);
        driver_support_html_parse($driver);
        driver_not_support_screenshot($driver);
    };

    context 'Scripting' => sub {
        $driver->visit($httpd->endpoint);
        driver_not_support_script($driver);
    };

    context 'Finder' => sub {
        $driver->visit($httpd->endpoint);
        driver_support_xpath_finder($driver);
        driver_support_css_selector_finder($driver);
    };
};

=comment
describe 'Brownie::Node::Mechanize' => sub {
    my $driver = Brownie::Driver::Mechanize->new;
    my $httpd = test_httpd;

    context 'Accessor' => sub {
        $driver->visit($httpd->endpoint);
        node_support_read_access($driver);
    };

    context 'Finder' => sub {
        $driver->visit($httpd->endpoint);
        node_support_inner_finder($driver);
    };

    context 'Action' => sub {
        $driver->visit($httpd->endpoint);
        node_support_state_check($driver);

        $driver->visit($httpd->endpoint);
        node_support_form_action($driver);
    };
};
=cut

done_testing;
