use Test::More;
use Test::Flatten;
use Test::Fake::HTTPD;

BEGIN {
    *describe = *context = *it = \&subtest;
}

use Brownie::Driver::Selenium;

my $httpd = run_http_server {
    my $html = <<'EOF';
<html>
<head><title>test</title></head>
<body>
<ul>
<li>1</li>
<li class="even">2</li>
<li>3</li>
<li class="even">4</li>
<li>5</li>
</ul>
</body>
</html>
EOF
    [ 200, ['Content-Type', 'text/html;charset=utf-8'], [$html] ];
};

my $driver = Brownie::Driver::Selenium->new;
$driver->visit($httpd->endpoint);

describe 'Brownie::Driver::Selenium#find_elements' => sub {
    it 'should accept xpath' => sub {
        is scalar($driver->find_elements('//li')) => 5;
        is scalar($driver->find_elements('//li[@class="even"]')) => 2;
    };

    it 'should accept css selector' => sub {
        is scalar($driver->find_elements('li')) => 5;
        is scalar($driver->find_elements('li.even')) => 2;
    };
};

describe 'Brownie::Driver::Selenium#find_element' => sub {
    it 'should accept xpath' => sub {
        is $driver->find_element('//li')->native->get_text => '1';
        is $driver->find_element('//li[@class="even"]')->native->get_text => '2';
    };

    it 'should accept css selector' => sub {
        is $driver->find_element('li')->native->get_text => '1';
        is $driver->find_element('li.even')->native->get_text => '2';
    };
};

done_testing;
