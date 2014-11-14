#!/usr/bin/perl

use warnings;
use strict;

use Getopt::Long;
use Proc::ProcessTable;
use Data::Dumper;

my $username = undef;
my $process = undef;

GetOptions (
	"username=s" => \$username,
	"process=s" => \$process,
);

my %procs;
my $procs = \%procs;

my $proc = new Proc::ProcessTable;
my $ref = $proc->table;

foreach my $p (@{$ref}) {
	my $user = getpwuid($p->{uid});
	push @{$procs->{$user}->{$p->{fname}}}, $p->{pid};
}

if (defined($username) && defined($process)) {
	foreach my $pid (@{$procs->{$username}->{$process}}) {
		if (opendir my $fddir, "/proc/$pid/fd") {
			my $fd = () = readdir($fddir);
			closedir $fddir;
			print "$pid: ".($fd - 3)."\n";
		}
	}
}

#print Dumper($procs);
