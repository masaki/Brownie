package Test::Brownie::SharedExamples::Driver;

use strict;
use warnings;
use parent 'Exporter';
use Test::More;
use Test::Data qw(Scalar);
use Test::Exception;
use Test::File;
use File::Temp;

sub import { __PACKAGE__->export_to_level(2, @_) }

sub driver_support_navigation {
    my ($driver, $httpd) = @_;

    lives_ok { $driver->visit($httpd->endpoint) };

    like $driver->current_url  => qr!@{[$httpd->endpoint]}/?!;
    like $driver->current_path => qr!^/?$!;
}

sub driver_support_status_code {
    my $driver = shift;

    is $driver->status_code => '200';
}

sub driver_not_support_status_code {
    my $driver = shift;
    dies_ok { $driver->status_code };
}

sub driver_support_header_access {
    my $driver = shift;

    my $headers = $driver->response_headers;
    isa_ok $headers => 'HTTP::Headers';

    my $ct = $headers->header('Content-Type');
    like $ct => qr!text/html!i;
    like $ct => qr/charset=utf-8/i;
}

sub driver_not_support_header_access {
    my $driver = shift;
    dies_ok { $driver->response_headers };
}

sub driver_support_html_parse {
    my $driver = shift;

    is $driver->title => 'test';

    my $data = $driver->source;
    like $data => qr!<html.+</html>!s;
    like $data => qr!<title>test</title>!;
}

sub driver_support_screenshot {
    my $driver = shift;

    my $path = File::Temp->new(UNLINK => 1, suffix => '.png')->filename;
    file_not_exists_ok $path;

    $driver->screenshot($path);
    file_exists_ok $path;
    file_not_empty_ok $path;

    unlink $path;
}

sub driver_not_support_screenshot {
    my $driver = shift;
    dies_ok { $driver->screenshot };
}

sub driver_support_script {
    my $driver = shift;

    subtest 'execute valid script' => sub {
        lives_ok { $driver->execute_script("document.title='execute_script'") };
        is $driver->title => 'execute_script';
    };

    subtest 'execute invalid script' => sub {
        dies_ok { $driver->execute_script(__PACKAGE__) };
        dies_ok { $driver->execute_script('%') };
    };

    subtest 'evaluate valid script' => sub {
        my $result = $driver->evaluate_script('1 + 2');
        is $result => 3;
    };

    subtest 'evaluate DOM script' => sub {
        my $result = $driver->evaluate_script('document.body');
        blessed_ok $result;
    };
}

sub driver_not_support_script {
    my $driver = shift;
    dies_ok { $driver->execute_script("document.title='execute_script'") };
    dies_ok { $driver->evaluate_script('1 + 2') };
}

sub driver_support_xpath_finder {
    my $driver = shift;

    subtest 'with xpath' => sub {
        is scalar($driver->find_elements('//li')) => 5;
        is scalar($driver->find_elements('//li[@class="even"]')) => 2;

        is $driver->find_element('//li')->text => '1';
        is $driver->find_element('//li[@class="even"]')->text => '2';
    };

    subtest 'return empty array when not exist locator was given' => sub {
        my @elems;
        lives_ok { @elems = $driver->find_elements('//span[@class="noexist"]') };
        is scalar(@elems) => 0;
    };
}

sub driver_support_css_selector_finder {
    my $driver = shift;

    subtest 'with css selector' => sub {
        is scalar($driver->find_elements('li')) => 5;
        is scalar($driver->find_elements('li.even')) => 2;

        is $driver->find_element('li')->text => '1';
        is $driver->find_element('li.even')->text => '2';
    };

    subtest 'return empty array when not exist locator was given' => sub {
        my @elems;
        lives_ok { @elems = $driver->find_elements('span.noexist') };
        is scalar(@elems) => 0;
    };
}

our @EXPORT;
{
    my $class = __PACKAGE__;
    no strict 'refs';
    for my $k (keys %{"${class}::"}) {
        next if $k =~ /^_/;
        next if $k =~ /^(?:BEGIN|CHECK|END|DESTROY)$/;
        next if $k =~ /^(?:import)$/;
        next unless *{"${class}::${k}"}{CODE};
        push @EXPORT, $k;
    }
}

1;
