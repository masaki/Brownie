use strict;
use warnings;
use Test::More;
use Brownie::Session;
use File::Spec;

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
        <label for="file1">File1 Label</label>
        <input type="file" id="file1" name="file1" value=""/>
      </p>
      <p>
        <label>File2 Label<input type="file" id="file2" name="file2" value=""/></label>
      </p>
    </form>
  </body>
</html>
__HTTPD__

    [ 200, [ 'Content-Type' => 'text/html;charset=utf-8' ], [$body] ];
};

my $bs = Brownie::Session->new(driver => 'Mechanize', app => $app);

subtest 'attach_file' => sub {
    my $file_path = File::Spec->rel2abs($0);

    for (
        ['file1',       'file1'],
        ['File1 Label', 'file1'],
        ['File2 Label', 'file2'],
    ) {
        my ($locator, $id) = @$_;
        $bs->visit('/');

        ok $bs->attach_file($locator, $file_path);
        # XXX: should check whether file is uploaded
    }
};

done_testing;
