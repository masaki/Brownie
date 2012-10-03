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
  <head>
    <title>test title</title>
  </head>
  <body>
    <script type="text/javascript">var num = 1 + 1;</script>
    <h1>Heading 1</h1>
    <form>
      <input type="hidden" name="hidden" id="hidden" value="value"/>

      <input type="checkbox" name="check" id="check1" value="check1" checked="checked"/>
      <input type="checkbox" name="check" id="check2" value="check2"/>

      <input type="radio" name="radio" id="radio1" value="radio1" selected="selected"/>
      <input type="radio" name="radio" id="radio2" value="radio2"/>
   </form>
  </body>
</html>
__HTTPD__

my $httpd = Test::Fake::HTTPD->new(timeout => 30);
$httpd->run(sub { [ 200, [ 'Content-Type' => 'text/html; charset=utf-8' ], [ $body ] ] });

my $base_url = $httpd->endpoint;

subtest 'State' => sub {
    $driver->visit($base_url);
    my $doc = $driver->find('/html');

    subtest 'visibility' => sub {
        ok $doc->find('h1')->is_displayed;

        ok $doc->find('head')->is_not_displayed;
        ok $doc->find('script')->is_not_displayed;
        ok $doc->find('#hidden')->is_not_displayed;
    };

    subtest 'selection' => sub {
        ok $doc->find('#check1')->is_checked;
        ok $doc->find('#radio1')->is_selected;

        ok $doc->find('#check2')->is_not_checked;
        ok $doc->find('#radio2')->is_not_selected;
    };
};

done_testing;
