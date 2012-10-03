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
        <input type="checkbox" id="checkbox1" name="checkbox1" value="Checkbox1 Value" checked=""/>
        <label for="checkbox1">Checkbox1 Label</label>
      </p>
      <p>
        <label>
          <input type="checkbox" id="checkbox2" name="checkbox2" value="Checkbox2 Value" checked=""/>
          Checkbox2 Label
        </label>
      </p>

      <p>
        <input type="checkbox" id="checkbox3" name="checkbox3" value="Checkbox3 Value" checked="checked"/>
        <label for="checkbox3">Checkbox3 Label</label>
      </p>
      <p>
        <label>
          <input type="checkbox" id="checkbox4" name="checkbox4" value="Checkbox4 Value" checked="checked"/>
          Checkbox4 Label
        </label>
      </p>
    </form>
  </body>
</html>
__HTTPD__

    [ 200, [ 'Content-Type' => 'text/html;charset=utf-8' ], [$body] ];
};

my $bs = Brownie::Session->new(driver => 'Mechanize', app => $app);

subtest 'check' => sub {
    for (
        [ checkbox1 => [ 'checkbox1', 'Checkbox1 Label', 'Checkbox1 Value' ] ],
        [ checkbox2 => [ 'checkbox2', 'Checkbox2 Label', 'Checkbox2 Value' ] ],
    ) {
        my ($id, $locators) = @$_;

        for my $locator (@$locators) {
            $bs->visit('/');

            ok $bs->check($locator);
            $bs->click_button('submit');
            ok $bs->current_url->query_param($id);
        }
    }
};

subtest 'uncheck' => sub {
    for (
        [ checkbox3 => [ 'checkbox3', 'Checkbox3 Label', 'Checkbox3 Value' ] ],
        [ checkbox4 => [ 'checkbox4', 'Checkbox4 Label', 'Checkbox4 Value' ] ],
    ) {
        my ($id, $locators) = @$_;

        for my $locator (@$locators) {
            $bs->visit('/');

            ok $bs->uncheck($locator);
            $bs->click_button('submit');
            ok not $bs->current_url->query_param($id);
        }
    }
};

done_testing;
