use Test::More;
use Test::Brownie;
use Brownie::Session;

describe 'Brownie::Session (Selenium)' => sub {
    my $session = Brownie::Session->new(driver_name => 'Selenium');
    my $httpd = test_httpd;

    context 'Action' => sub {
        my $base_url = $httpd->endpoint;
        session_support_click_action($session, $base_url);
        session_support_form_action($session, $base_url);
    };
};

done_testing;
