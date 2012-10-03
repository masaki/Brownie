use strict;
use warnings;
use Test::More;
use Test::Fake::HTTPD;
use Test::Exception;
use Brownie::Driver::Mechanize;
use Brownie::Node::Mechanize;

my $driver = Brownie::Driver::Mechanize->new;

my $body = <<__HTTPD__;
<html>
  <head><title>test title</title></head>
  <body>
    <ul>
      <li>li 1</li>
      <li class="even">li 2</li>
      <li>li 3</li>
      <li class="even">li 4</li>
      <li>li 5</li>
    </ul>

    <p>outer paragraph</p>
    <div id="parent">
      <p>inner paragraph</p>
    </div>
  </body>
</html>
__HTTPD__

my $httpd = Test::Fake::HTTPD->new(timeout => 30);
$httpd->run(sub { [ 200, [ 'Content-Type' => 'text/html; charset=utf-8' ], [ $body ] ] });

my $base_url = $httpd->endpoint;

subtest 'Finder' => sub {
    $driver->visit($base_url);
    my $doc = $driver->find('/html');

    subtest 'using XPath' => sub {
        subtest 'all' => sub {
            is scalar($doc->all('//li'))                => 5;
            is scalar($doc->all('//li[@class="even"]')) => 2;

            subtest 'empty when not exist locator' => sub {
                lives_ok {
                    my @elems = $doc->all('//span[@class="noexist"]');
                    is scalar(@elems) => 0;
                };
            };
        };

        subtest 'find' => sub {
            is $doc->find('//li')->text                => 'li 1';
            is $doc->find('//li[@class="even"]')->text => 'li 2';

            subtest 'child element' => sub {
                my $base = $doc->find('//div[@id="parent"]');
                my $child = $base->find('//p');
                is $child->text => 'inner paragraph';
            };
        };
    };

    subtest 'using CSS Selector' => sub {
        subtest 'all' => sub {
            is scalar($doc->all('li'))      => 5;
            is scalar($doc->all('li.even')) => 2;

            subtest 'empty when not exist locator' => sub {
                lives_ok {
                    my @elems = $doc->all('span.noexist');
                    is scalar(@elems) => 0;
                };
            };
        };

        subtest 'find' => sub {
            is $doc->find('li')->text      => 'li 1';
            is $doc->find('li.even')->text => 'li 2';

            subtest 'child element' => sub {
                my $base = $doc->find('#parent');
                my $child = $base->find('p');
                is $child->text => 'inner paragraph';
            };
        };
    };
};

done_testing;
