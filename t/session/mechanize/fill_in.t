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
      <input type="submit" id="submit" name="submit" value="submit"/>

      <!-- text field -->
      <p>
        <label for="text1">Text1 Label</label>
        <input type="text" id="text1" name="text1" value="Text1 Value" title="Text1 Title"/>
        <label for="text2">Text2 Label</label>
        <input             id="text2" name="text2" value="Text2 Value" />
      </p>
      <!-- textarea -->
      <p>
        <label for="textarea1">Textarea1 Label</label>
        <textarea id="textarea1" name="textarea1">Textarea1 Text</textarea>
        <label>Textarea2 Label<textarea id="textarea2" name="textarea2">Textarea2 Text</textarea></label>
      </p>
      <!-- password -->
      <p>
        <label for="password1">Password1 Label</label>
        <input type="password" id="password1" name="password1" value=""/>
      </p>
      <!-- hidden -->
      <input type="hidden" id="hidden1" name="hidden1" value="Hidden1 Value"/>
    </form>
  </body>
</html>
__HTTPD__

    [ 200, [ 'Content-Type' => 'text/html;charset=utf-8' ], [$body] ];
};

my $bs = Brownie::Session->new(driver => 'Mechanize', app => $app);

subtest 'fill_in' => sub {
    for my $locator (
        'text1',     'Text1 Label',     'Text1 Title',
        'text2',     'Text2 Label',
        'password1', 'Password1 Label',
        'textarea1', 'Textarea1 Label',
        'textarea2', 'Textarea2 Label',
        'hidden1',
    ) {
        $bs->visit('/');
        my $value = time . $$;

        unlike $bs->current_url => qr/$value/;

        ok $bs->fill_in($locator, $value);
        $bs->click_button('submit');

        like $bs->current_url => qr/$value/;
    }
};

done_testing;
