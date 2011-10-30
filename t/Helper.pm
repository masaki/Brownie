package t::Helper;

use strict;
use warnings;
use Exporter 'import';
use Test::Fake::HTTPD;

our @EXPORT = qw(test_httpd);

sub test_httpd {
    my $content = shift || <<'EOF';
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <title>test</title>
  </head>
  <body>
    <h1 id="current_path">%s</h1>

    <ul>
      <li>1</li>
      <li class="even">2</li>
      <li>3</li>
      <li class="even">4</li>
      <li>5</li>
    </ul>

    <p id="navigation">
      <a href="/id" id="link_id">Link</a>
      <a href="/xpath">Link</a>
      <a href="/text">Text of Link</a>
      <a href="/title" title="Title of Link">Link</a>
      <a href="/img/alt"><img src="" alt="Alt of Image"/></a>
    </p>

    <form action="/form" method="get">
      <input type="submit" id="input_submit" title="Input Submit Title" value="Input Submit Value"/>
      <input type="image" id="input_image" title="Input Image Title" alt="Input Image Alt"/>
      <button type="submit" id="button_submit" title="Button Submit Title" value="Button Submit Value">Button Submit</button>
      <input type="button" id="input_button" title="Input Button Title" value="Input Button Value" onclick="javascript:location.href='/js'"/>
      <button type="button" id="button_button" title="Button Button Title" value="Button Button Value" onclick="javascript:location.href='/js'">Button Button</button>
    </form>
  </body>
</html>
EOF

    run_http_server {
        my $req = shift;
        my $body = sprintf $content, $req->uri->path;
        return [ 200, ['Content-Type', 'text/html;charset=utf-8'], [$body] ];
    }
};

1;
