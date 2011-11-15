use Test::More;
use Test::Brownie;
use Brownie::Driver::Selenium;
use Brownie::Node::Selenium;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd();
$driver->visit($httpd->endpoint);

sub elem ($) { $driver->find_element($_[0]) }

describe 'Brownie::Node::Selenium#attr' => sub {
    it 'should access to any attribute' => sub {
        is elem('h1')->attr('id') => 'current_path';
    };
};

describe 'Brownie::Node::Selenium#value' => sub {
    it 'should access to value attribute' => sub {
        is elem('#input_submit')->value => 'Input Submit Value';
    };
};

describe 'Brownie::Node::Selenium#text' => sub {
    it 'should access to child text node' => sub {
        is elem('h1')->text => '/';
    };
};

describe 'Brownie::Node::Selenium#tag_name' => sub {
    it 'should return tag name' => sub {
        is elem('h1')->tag_name => 'h1';
    };
};

done_testing;
