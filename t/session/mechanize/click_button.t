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
    <form action="/form" method="get">
      <input type="submit" id="input_submit" title="Input Submit Title" value="Input Submit Value"/>
      <input type="image" id="input_image" title="Input Image Title" alt="Input Image Alt" value="Input Image Value"/>
      <button type="submit" id="button_submit" title="Button Submit Title" value="Button Submit Value">Button Submit</button>
      <input type="button" id="input_button" title="Input Button Title" value="Input Button Value" onclick="javascript:location.href='/js'"/>
      <button type="button" id="button_button" title="Button Button Title" value="Button Button Value" onclick="javascript:location.href='/js'">Button Button</button>
    </form>
  </body>
</html>
__HTTPD__

    [ 200, [ 'Content-Type' => 'text/html;charset=utf-8' ], [$body] ];
};

my $bs = Brownie::Session->new(driver => 'Mechanize', app => $app);

my @buttons = (
    'input_submit',
    'Input Submit Title',
    'Input Submit Value',
    'button_submit',
    'Button Submit Title',
    'Button Submit Value',
    'Button Submit',
);

subtest 'click_button' => sub {
    for my $locator (@buttons) {
        $bs->visit('/');

        is $bs->current_path => '/';
        ok $bs->click_button($locator);
        is $bs->current_path => '/form';
    }
};

subtest 'click_button' => sub {
    for my $locator (@buttons) {
        $bs->visit('/');

        is $bs->current_path => '/';
        ok $bs->click_link_or_button($locator);
        is $bs->current_path => '/form';
    }
};

done_testing;
