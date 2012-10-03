use strict;
use warnings;
use Test::More;
use Brownie::Session;
use URI::QueryParam;

my $app = sub {
    my $body = <<__HTTPD__;
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <title>test</title>
  </head>
  <body>
    <form action="/form" method="get">
      <input type="submit" id="submit" name="submit" value="submit"/>

      <p>
        <input type="radio" id="radio1" name="radio" value="Radio1 Value"/>
        <label for="radio1">Radio1 Label</label>
      </p>
      <p>
        <label>
          <input type="radio" id="radio2" name="radio" value="Radio2 Value" checked="checked"/>
          Radio2 Label
        </label>
      </p>
      <p>
        <label>
          <input type="radio" id="radio3" name="radio" value="Radio3 Value"/>
          Radio3 Label
        </label>
      </p>
    </form>
  </body>
</html>
__HTTPD__

    [ 200, [ 'Content-Type' => 'text/html;charset=utf-8' ], [$body] ];
};

my $bs = Brownie::Session->new(driver => 'Mechanize', app => $app);

subtest 'choose' => sub {
    for (
        [ 'Radio1 Value' => [ 'radio1', 'Radio1 Label', 'Radio1 Value' ] ],
        [ 'Radio2 Value' => [ 'radio2', 'Radio2 Label', 'Radio2 Value' ] ],
        [ 'Radio3 Value' => [ 'radio3', 'Radio3 Label', 'Radio3 Value' ] ],
    ) {
        my ($value, $locators) = @$_;

        for my $locator (@$locators) {
            $bs->visit('/');

            ok $bs->choose($locator);
            $bs->click_button('submit');
            is $bs->current_url->query_param('radio') => $value;
        }
    }
};

done_testing;
