#!/usr/bin/perl

open(PRTCP, '/proc/net/tcp');

while(<PRTCP>)
{
    chomp;
    next if /^\s*$/;
    s/^\s*//;
    s/\s*$//;
    next if /^sl/;
    split/\s+/;
    @p = split ':', $_[1];
    $h{hex $p[1]} = $_[7];
}

foreach(sort{$a<=>$b}keys%h)
{
    print $_, "\t", [getpwuid($h{$_})]->[0], "\n"
};
