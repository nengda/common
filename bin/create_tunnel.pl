#!/home/y/bin/perl

my ($host, $port) = split(/:/, $ARGV[0]);
my $host_ip = `host $host`;
chomp $host_ip;
$host_ip = $1 if ($host_ip =~ /(\S+)$/);
my $local_port = -1;
while ($local_port == -1) {
    my $p = int(rand(55536)) + 10000;
    $local_port = $p if (length(`ports.pl | grep $p`) == 0);
}
my $gateway = ($ARGV[1]) ? $ARGV[1] : 'login1.corp.yahoo.com';
print "Creating tunnel to \"$host_ip:$port\" at local port \"$local_port\"\n";
my $list_iptable_command = "sudo /sbin/iptables --list -t nat --line-numbers --numeric | grep $host_ip";
print $list_iptable_command . "\n";
my @old_entries = split /\n/, `$list_iptable_command`;
for (my $i = scalar(@old_entries) - 1; $i >= 0; $i--) {
    my $rule_num = $1 if ($old_entries[$i] =~ /^(\d+)/);
    my $delete_command = "sudo /sbin/iptables -t nat -D OUTPUT $rule_num";
    print $delete_command . "\n";
    system($delete_command);
}
my $iptable_command = "sudo /sbin/iptables -t nat -A OUTPUT -p tcp -d $host --dport $port -j DNAT --to 127.0.0.1:$local_port";
print $iptable_command . "\n";
system($iptable_command);
my $ssh_command = "yssh -N -f -L $local_port:$host:$port $ENV{USER}\@$gateway";
print $ssh_command . "\n";
system($ssh_command);
exit;

