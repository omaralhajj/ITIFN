#! /usr/bin/perl -w
# udpclient.pl - a simple client
#----------------

use IO::Socket::INET;

# Host and port can be specified as an arg, otherwise they default
my $host = shift || 'localhost';
my $port = shift || 7890;
 
# create a connecting socket, udp now i guess
my $socket = new IO::Socket::INET (
    $host,
    $port,
    Proto => 'udp',
);
die "cannot connect to the server $!\n" unless $socket;
print "connected to the server\n";

# Send a datagram first, because this is udp. RFC states it should be empty.
my $datagram = "";
$socket->send($datagram);

# recieving data from server
my $data;
$socket->recv($data, 4);
# Unpacking recieved data
my $time = unpack("l", $data);
# Time since 1900 
my $updatedtime = $time + 2208988800;
print "The recieved time in seconds since midnight January 1st 1900, $updatedtime corresponds to:";
# converting to, and printing, local time
print "".localtime($time);
print "\n";
 
$socket->close();