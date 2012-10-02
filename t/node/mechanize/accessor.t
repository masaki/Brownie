use strict;
use warnings;
use Test::More;
use t::Utils;
use Test::Exception;
use Brownie::Driver::Mechanize;
use Brownie::Node::Mechanize;

my $driver = Brownie::Driver::Mechanize->new;

my $httpd = run_httpd_with(<<__HTTPD__);
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
