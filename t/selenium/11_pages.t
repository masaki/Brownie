use Test::More;
use Test::Brownie;
use Test::File;
use File::Temp;
use Brownie::Driver::Selenium;

my $driver = Brownie::Driver::Selenium->new;
my $httpd = test_httpd;
$driver->visit($httpd->endpoint);

describe 'Brownie::Driver::Selenium#title' => sub {
    it 'should get <title> text' => sub {
        is $driver->title => 'test';
    };
};

describe 'Brownie::Driver::Selenium#source' => sub {
    it 'should return raw content' => sub {
        my $data = $driver->source;
        like $data => qr!<html.+</html>!s;
        like $data => qr!<title>test</title>!;
    };
};

describe 'Brownie::Driver::Selenium#screenshot' => sub {
    it 'should save screenshot file' => sub {
        my $path = File::Temp->new(UNLINK => 1, suffix => '.png')->filename;
        file_not_exists_ok $path;

        $driver->screenshot($path);
        file_exists_ok $path;
        file_not_empty_ok $path;

        unlink $path;
    };
};

done_testing;
