package Test::Brownie::HTTPD;

use strict;
use warnings;
use parent 'Exporter';
use Test::Fake::HTTPD;
use Data::Section::Simple qw(get_data_section);

our @EXPORT = qw(test_httpd);

sub import {
    __PACKAGE__->export_to_level(2, @_);
}

sub test_httpd {
    my $content = shift || get_data_section('index.html');

    my $httpd = Test::Fake::HTTPD->new(timeout => 30);
    $httpd->run(sub {
        my $req = shift;
        my $body = sprintf $content, $req->uri->path;
        return [ 200, ['Content-Type', 'text/html;charset=utf-8'], [$body] ];
    });

    $httpd;
};

1;

__DATA__

@@ index.html
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <title>test</title>
  </head>
  <body>
    <script type="text/javascript">var n = 1 + 2;</script>
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

      <p>
        <label for="input_text">Input Text Label</label>
        <input type="text" id="input_text" value="Input Text Value" title="Input Text Title"/>
        <label for="input_text2">INput Text2 Label</label>
        <input id="input_text2" name="input_text2" value="Input Text2 Value" />
      </p>
      <p>
        <label for="textarea">Textarea Label</label>
        <textarea id="textarea">Textarea Text</textarea>
      </p>
      <p><label>Inner Input Password Lavel<input type="password" id="input_password" value=""/></label></p>
      <p><label>Inner Textarea Lavel<textarea id="textarea2"></textarea></label></p>

      <input type="hidden" id="input_hidden" value="Hidden Value"/>

      <p>
        <label for="input_file1">File Label1</label><input type="file" id="input_file1" value=""/>
        <label>File Label2<input type="file" id="input_file2" value=""/></label>
      </p>

      <input type="checkbox" id="input_checkbox1" value="Checkbox1 Value"/><label for="input_checkbox1">checkbox1</label>
      <label><input type="checkbox" id="input_checkbox2" value="Checkbox2 Value" checked="checked"/>checkbox2</label>
      <input type="checkbox" id="input_checkbox3" value="Checkbox3 Value" checked="checked"/><label for="input_checkbox3">checkbox3</label>
      <label><input type="checkbox" id="input_checkbox4" value="Checkbox4 Value"/>checkbox4</label>

      <input type="radio" id="input_radio1" name="input_radio" value="Radio1 Value"/><label for="input_radio1">radio1</label>
      <label><input type="radio" id="input_radio2" name="input_radio" value="Radio2 Value" checked="checked"/>radio2</label>
      <label><input type="radio" id="input_radio3" name="input_radio" value="Radio3 Value"/>radio3</label>

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
