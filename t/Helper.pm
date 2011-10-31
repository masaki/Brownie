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

      <input type="text" id="input_text" value="Input Text Value"/>
      <textarea id="textarea">Textarea Text</textarea>
      <input type="hidden" id="input_hidden" value="Hidden Value"/>

      <input type="checkbox" id="input_checkbox1" value="Checkbox1 Value"/>checkbox1
      <input type="checkbox" id="input_checkbox2" value="Checkbox2 Value" checked="checked"/>checkbox2
      <input type="radio" id="input_radio1" name="input_radio" value="Radio1 Value"/>radio1
      <input type="radio" id="input_radio2" name="input_radio" value="Radio2 Value" checked="checked"/>radio2
      <select id="select_single">
        <option value="1" id="select_option1">o1</option>
        <option value="2" id="select_option2" selected="selected">o2</option>
        <option value="3" id="select_option3">o3</option>
      </select>
      <select id="select_multiple" multiple="multiple">
        <option value="4" id="select_option4">o4</option>
        <option value="5" id="select_option5" selected="selected">o5</option>
        <option value="6" id="select_option6" selected="selected">o6</option>
      </select>
    </form>

    <p>
      <a href="#" class="child">child1</a>
      <a href="#" class="child">child2</a>
    </p>
    <p id="parent">
      <a href="#" class="child">child3</a>
      <a href="#" class="child">child4</a>
    </p>
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
