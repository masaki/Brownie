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
    <h1 id="title" title="heading">Heading 1</h1>
    <form>
      <input type="text" name="text" id="text" value="text value"/>
    </form>
  </body>
</html>
__HTTPD__

my $httpd = Test::Fake::HTTPD->new(timeout => 30);
$httpd->run(sub { [ 200, [ 'Content-Type' => 'text/html; charset=utf-8' ], [ $body ] ] });

my $base_url = $httpd->endpoint;

subtest 'Accessor' => sub {
    $driver->visit($base_url);
    my $doc = $driver->find('/html');

    subtest 'text element' => sub {
        my $elem = $doc->find('h1');

        is $elem->tag_name      => 'h1';
        is $elem->text          => 'Heading 1';
        is $elem->id            => 'title';
        is $elem->attr('title') => 'heading';
    };

    subtest 'control element' => sub {
        my $elem = $doc->find('#text');

        is $elem->tag_name => 'input';
        is $elem->id       => 'text';
        is $elem->type     => 'text';
        is $elem->name     => 'text';
        is $elem->value    => 'text value';
    };
};

done_testing;
