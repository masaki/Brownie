use strict;
use warnings;
use Test::More;
use Brownie::Session;

my $app = sub {
    my $body = <<__HTTPD__;
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <title>test</title>
  </head>
  <body>
    <p id="navigation">
      <a href="/id" id="link_id">Link</a>
      <a href="/xpath">Link</a>
      <a href="/text">Text of Link</a>
      <a href="/title" title="Title of Link">Link</a>
      <a href="/img/alt"><img src="" alt="Alt of Image"/></a>
    </p>
  </body>
</html>
__HTTPD__

    [ 200, [ 'Content-Type' => 'text/html;charset=utf-8' ], [$body] ];
};

my $bs = Brownie::Session->new(driver => 'Mechanize', app => $app);

my @endpoints = (
    ['link_id',       '/id'],
    ['Text of Link',  '/text'],
    ['Title of Link', '/title'],
    ['Alt of Image',  '/img/alt'],
);

subtest 'click_link' => sub {
    for (@endpoints) {
        my ($locator, $path) = @$_;
        $bs->visit('/');

        is $bs->current_path => '/';
        ok $bs->click_link($locator);
        is $bs->current_path => $path;
    }
};

subtest 'click_link_or_button' => sub {
    for (@endpoints) {
        my ($locator, $path) = @$_;
        $bs->visit('/');

        is $bs->current_path => '/';
        ok $bs->click_link_or_button($locator);
        is $bs->current_path => $path;
    }
};

done_testing;
