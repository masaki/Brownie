use Test::More;
use Test::Flatten;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Session;
use t::Helper;

my $session = Brownie::Session->new(driver_name => 'Selenium');
my $httpd = test_httpd;

describe 'Brownie::Driver::Selenium#click_link' => sub {
    sub click_link_ok {
        my ($locator, $path) = @_;
        $session->visit($httpd->endpoint);
        $session->click_link($locator);
        is $session->current_path => $path;
    }

    it 'should click link with "#id" locator' => sub {
        click_link_ok('#link_id', '/id');
    };

    it 'should click link with "//xpath" locator' => sub {
        click_link_ok('//a[2]', '/xpath');
        click_link_ok('//a[@href="/xpath"]', '/xpath');
    };

    it 'should click link with "a[text()]" locator' => sub {
        click_link_ok('Text of Link', '/text');
    };

    it 'should click link with "a[@title]" locator' => sub {
        click_link_ok('Title of Link', '/title');
    };

    it 'should click link with "a/img[@alt]" locator' => sub {
        click_link_ok('Alt of Image', '/img/alt');
    };
};

=comment
describe 'Brownie::Driver::Selenium#click_button' => sub {
    sub should_click_button_and_go {
        my ($locator, $path) = @_;
        $driver->visit($url);
        $driver->click_button($locator);
        is $driver->current_path => $path;
    }

    it 'should click button with "#id" locator' => sub {
        my %map = (
            '#input_submit'  => '/form',
            '#input_button'  => '/js',
            '#input_image'   => '/form',
            '#button_submit' => '/form',
            '#button_button' => '/js',
        );
        for my $id (keys %map) {
            should_click_button_and_go($id, $map{$id});
        }
    };

    it 'should click button with "//xpath" locator' => sub {
        should_click_button_and_go('//input[1]', '/form');
        should_click_button_and_go('//input[2]', '/js');
    };

    it 'should click button with "input[@title]" locator' => sub {
        should_click_button_and_go('Input Submit Title', '/form');
    };
    it 'should click button with "input[@value]" locator' => sub {
        should_click_button_and_go('Input Submit Value', '/form');
    };
    it 'should click button with "button[@title]" locator' => sub {
        should_click_button_and_go('Button Submit Title', '/form');
    };
    it 'should click button with "button[@value]" locator' => sub {
        should_click_button_and_go('Button Submit Value', '/form');
    };
    it 'should click button with "button[text()]" locator' => sub {
        should_click_button_and_go('Button Submit', '/form');
    };
};

describe 'Brownie::Driver::Selenium#click_on' => sub {
    sub should_click_and_go {
        my ($locator, $path) = @_;
        $driver->visit($url);
        $driver->click_on($locator);
        is $driver->current_path => $path;
    }

    it 'should click link' => sub {
        should_click_and_go('#link_id', '/link_id');
    };

    it 'should click button' => sub {
        should_click_and_go('Input Submit Title', '/form');
    };
};
=cut

done_testing;
