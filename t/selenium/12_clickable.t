use Test::More;
use Test::Flatten;
use Test::Fake::HTTPD;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;

my $driver = Brownie::Driver::Selenium->new;

my $httpd = run_http_server {
    my $content = <<'EOF';
<html>
  <body>
    <p>
      <a href="/link_id" id="link_id">Link</a>
      <a href="/link_xpath">Link</a>
      <a href="/link_text">Text Link</a>
      <a href="/link_title" title="Title Link">Link</a>
      <a href="/link_img"><img src="" alt="ImgAlt Link"/></a>
    </p>
    <form action="/form">
      <input type="submit" id="input_submit" title="Input Submit Title" value="Input Submit Value"/>
      <input type="button" id="input_button" title="Input Button Title" value="Input Button Value" onclick="javascript:location.href='/js'"/>
      <input type="image" id="input_image" title="Input Image Title" alt="Input Image Alt"/>
      <button type="submit" id="button_submit" title="Button Submit Title" value="Button Submit Value">Button Submit</button>
      <button type="button" id="button_button" title="Button Button Title" value="Button Button Value" onclick="javascript:location.href='/js';return false">Button Button</button>
    </form>
  </body>
</html>
EOF

    return [ 200, ['Content-Type', 'text/html;charset=utf-8'], [$content] ];
};

my $url = sprintf 'http://127.0.0.1:%d/', $httpd->port;

describe 'Brownie::Driver::Selenium#click_link' => sub {
    sub should_click_link_and_go {
        my ($locator, $path) = @_;
        $driver->visit($url);
        $driver->click_link($locator);
        is $driver->current_path => $path;
    }

    it 'should click button with "#id" locator' => sub {
        should_click_link_and_go('#link_id', '/link_id');
    };

    it 'should click link with "//xpath" locator' => sub {
        should_click_link_and_go('//a[2]', '/link_xpath');
        should_click_link_and_go('//a[@href="/link_xpath"]', '/link_xpath');
    };

    it 'should click link with "a[text()]" locator' => sub {
        should_click_link_and_go('Text Link', '/link_text');
    };

    it 'should click link with "a[@title]" locator' => sub {
        should_click_link_and_go('Title Link', '/link_title');
    };

    it 'should click link with "a/img[@alt]" locator' => sub {
        should_click_link_and_go('ImgAlt Link', '/link_img');
    };
};

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

done_testing;
