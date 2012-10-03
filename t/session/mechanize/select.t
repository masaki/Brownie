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

      <select id="single" name="single">
        <option value="Option1 Value" id="option1"                    >Option1 Text</option>
        <option value="Option2 Value" id="option2" selected="selected">Option2 Text</option>
        <option value="Option3 Value" id="option3"                    >Option3 Text</option>
      </select>

      <select id="multiple" name="multiple" multiple="multiple">
        <option value="Option4 Value" id="option4"                    >Option4 Text</option>
        <option value="Option5 Value" id="option5"                    >Option5 Text</option>
        <option value="Option6 Value" id="option6" selected="selected">Option6 Text</option>
      </select>
    </form>
  </body>
</html>
__HTTPD__

    [ 200, [ 'Content-Type' => 'text/html;charset=utf-8' ], [$body] ];
};

my $bs = Brownie::Session->new(driver => 'Mechanize', app => $app);

subtest 'select' => sub {
    subtest 'single' => sub {
        for (
            [ 'Option1 Value' => [ 'option1', 'Option1 Value', 'Option1 Text' ] ],
            [ 'Option2 Value' => [ 'option2', 'Option2 Value', 'Option2 Text' ] ],
            [ 'Option3 Value' => [ 'option3', 'Option3 Value', 'Option3 Text' ] ],
        ) {
            my ($value, $locators) = @$_;

            for my $locator (@$locators) {
                $bs->visit('/');

                ok $bs->select($locator);
                $bs->click_button('submit');
                is $bs->current_url->query_param('single') => $value;
            }
        }
    };

    subtest 'multiple' => sub {
        for (
            [ 'Option4 Value' => [ 'option4', 'Option4 Value', 'Option4 Text' ] ],
            [ 'Option5 Value' => [ 'option5', 'Option5 Value', 'Option5 Text' ] ],
        ) {
            my ($value, $locators) = @$_;

            for my $locator (@$locators) {
                $bs->visit('/');

                ok $bs->select($locator);
                $bs->click_button('submit');

                ok my @params = $bs->current_url->query_param('multiple');
                is scalar(@params) => 2;
                is $params[0]  => $value;
                is $params[-1] => 'Option6 Value';
            }
        }
    };
};

=comment

subtest 'unselect' => sub {
    my @params = (
        ['select_option5', 'select_option5'],
        ['5', 'select_option5'],
        ['o5', 'select_option5'],
    );

    for (@params) {
        my ($locator, $id) = @$_;
        $bs->visit($base_url);

        my $node = $bs->find_element("#$id");
        ok $node->is_selected;
        ok $bs->unselect($locator);
        ok $node->is_not_selected;
    }
};

=cut

done_testing;
