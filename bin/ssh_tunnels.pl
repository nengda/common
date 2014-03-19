#!/home/y/bin/perl

use warnings;
use strict;

use Log::Log4perl;
use File::Temp qw/tempfile/;

Log::Log4perl->easy_init({
    level   => "INFO",
    file    => 'STDOUT',
    layout  => '[%d] %c - %m%n',
});

my $_logger = Log::Log4perl::get_logger(__PACKAGE__);

my $hosts = [
    '17098:sastdts.yahoofs.com:80',
    '64180:phazontan-nn1-pxy.tan.ygrid.yahoo.com:4443',
];

my $gateway_host = 'ne1-qadtsms-001.ysm.pool.ne1.yahoo.com';
for (@$hosts) {
    my ($local_port, $dest_host, $dest_port) = split /:/;
    create_tunnel($dest_host, $dest_port, $local_port, $gateway_host);
}

sub create_tunnel {
    my ($d_host, $d_port, $l_port, $gateway) = @_;
    my $cmd = "yssh -N -f -L $l_port:$d_host:$d_port $gateway";
    $_logger->info("Creating tunnel for '$d_host' through '$gateway'...");
    my $tempfile = "tunnel_test.tmp";
    my $test_cmd = "echo quit | telnet 127.0.0.1 $l_port 2> $tempfile";

    system($test_cmd);
    open (CON, $tempfile);
    my $test_connection = <CON>;

    if ($test_connection =~ /Connection refused/){
        $_logger->info("tunnel is not created, create tunnel...");
        system($cmd);
        $_logger->info("create tunnel done...");
    } elsif ($test_connection =~ /Connection closed/) {
        $_logger->info("tunnel already created, doing nothing...");
    } else {
        $_logger->warn("failed to read connection test message: $test_connection");
    }
    close CON;
    unlink $tempfile;
}
