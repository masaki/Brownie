use Test::More;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Session;
use t::Helper;

my $session = Brownie::Session->new(driver_name => 'Selenium');
my $httpd = test_httpd;

describe 'Brownie::Session#click_link' => sub {
    sub click_link_ok {
        my $locator = shift;
        $session->visit($httpd->endpoint);
        my $url = $session->current_url;
        $session->click_link($locator);
        isnt $session->current_url => $url;
    }

    it 'should click link with #id' => sub {
        click_link_ok('link_id');
    };
    it 'should click link with text()' => sub {
        click_link_ok('Text of Link');
    };
    it 'should click link with @title' => sub {
        click_link_ok('Title of Link');
    };
    it 'should click link with a/img[@alt]' => sub {
        click_link_ok('Alt of Image');
    };
};

describe 'Brownie::Session#click_button' => sub {
    sub click_button_ok {
        my $locator = shift;
        $session->visit($httpd->endpoint);
        my $url = $session->current_url;
        $session->click_button($locator);
        isnt $session->current_url => $url;
    }

    it 'should click button with #id' => sub {
        my @id = qw(input_submit input_button input_image button_submit button_button);
        for my $id (@id) {
            click_button_ok($id);
        }
    };

    it 'should click button with input[@title] and input[@value]' => sub {
        click_button_ok('Input Submit Title');
        click_button_ok('Input Submit Value');
    };
    it 'should click button with button[@title] and button[@value] and button[text()]' => sub {
        click_button_ok('Button Submit Title');
        click_button_ok('Button Submit Value');
        click_button_ok('Button Submit');
    };
};

describe 'Brownie::Session#click_on' => sub {
    sub click_ok {
        my $locator = shift;
        $session->visit($httpd->endpoint);
        my $url = $session->current_url;
        $session->click_on($locator);
        isnt $session->current_url => $url;
    }

    it 'should click link' => sub {
        click_ok('link_id');
    };

    it 'should click button' => sub {
        click_ok('Input Submit Title');
    };
};

done_testing;
