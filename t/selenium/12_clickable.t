use Test::More;
use Test::Flatten;
BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;
use t::lib::httpd_helper;
use HTTP::Response;

my $driver = Brownie::Driver::Selenium->new;

my $server = start_http_server {
    my $req = shift;
    my $res = HTTP::Response->new(200);
    $res->content(<<'EOF');
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
<input type="submit"/>
<input type="submit"/>
<input type="submit"/>
</form>
</body>
</html>
EOF
    return $res;
};
my $url = sprintf 'http://127.0.0.1:%d/', $server->port;

describe 'Brownie::Driver::Selenium#click_link' => sub {
    sub should_click_link_and_go_to_next_page {
        my ($locator, $path) = @_;
        $driver->visit($url);
        $driver->click_link($locator);
        is $driver->current_path => $path;
    }

    it 'should click link with "#id" locator' => sub {
        should_click_link_and_go_to_next_page('#link_id', '/link_id');
    };
    it 'should click link with "//xpath" locator' => sub {
        should_click_link_and_go_to_next_page('//a[2]', '/link_xpath');
        should_click_link_and_go_to_next_page('//a[@href="/link_xpath"]', '/link_xpath');
    };
    it 'should click link with "a[text()]" locator' => sub {
        should_click_link_and_go_to_next_page('Text Link', '/link_text');
    };
    it 'should click link with "a[@title]" locator' => sub {
        should_click_link_and_go_to_next_page('Title Link', '/link_title');
    };
    it 'should click link with "a/img[@alt]" locator' => sub {
        should_click_link_and_go_to_next_page('ImgAlt Link', '/link_img');
    };
};

done_testing;
