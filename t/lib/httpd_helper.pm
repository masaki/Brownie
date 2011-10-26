package t::lib::httpd_helper;

use strict;
use warnings;
use Test::TCP;
use HTTP::Daemon;
use Exporter 'import';

our @EXPORT = qw(start_http_server);

sub start_http_server (&) {
    my $process_request = shift;
    my $server = Test::TCP->new(
        code => sub {
            my $port = shift;
            my $httpd = HTTP::Daemon->new(LocalAddr => '127.0.0.1', LocalPort => $port);
            while (my $context = $httpd->accept) {
                while (my $req = $context->get_request) {
                    my $res = $process_request->($req);
                    $context->send_response($res);
                }
                $context->close; undef $context;
            }
        },
    );

    my $guard = bless { server => $server }, __PACKAGE__;
    return $guard;
}

sub port { shift->{server}->port }

sub DESTROY {
    my $self = shift;
    if ($self->{server}) {
        $self->{server}->stop;
        undef $self->{server};
    }
}

1;
