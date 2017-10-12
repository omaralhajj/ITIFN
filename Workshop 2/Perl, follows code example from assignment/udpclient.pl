#! /usr/bin/perl -w
# udpclient.pl - a simple client
#----------------

use strict;
use Socket;

# initialize host and port
my $host = shift || 'localhost';
my $port = shift || 9000;

my $proto = getprotobyname('udp');

# get the port address
my $iaddr = inet_aton($host);
my $paddr = sockaddr_in($port, $iaddr);

# create the socket, connect to the port
socket(SOCKET, PF_INET, SOCK_STREAM, $proto) or die "socket: $!\n";
connect(SOCKET, $paddr) or die "connect: $!\n";

my $datagram = "";
send(SOCKET, $datagram, 10);

my $data;
recv(SOCKET, $data, 4, 0);
# converting from binary to decimal
my $time = unpack("l", $data);
# Time since 1900 
#my $updatedtime = $time + 2208988800;
print "The recieved time in seconds since midnight January 1st 1900, $time corresponds to:";
# converting to, and printing, local time
print "".localtime($time);
print "\n";
close SOCKET or die "close: $!";