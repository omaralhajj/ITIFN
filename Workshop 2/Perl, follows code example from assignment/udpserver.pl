#! /usr/bin/perl -w 
# udpserver.pl 
#-------------------- 

use strict; 
use Socket; 

# use port 7890 as default 
my $port = shift || 7890; 
my $proto = getprotobyname('udp'); 

# create a socket, make it reusable 
socket(SERVER, PF_INET, SOCK_STREAM, $proto) or die "socket: $!\n"; 
setsockopt(SERVER, SOL_SOCKET, SO_REUSEADDR, 1) or die "setsock: $!\n"; 

# grab a port on this machine 
my $paddr = sockaddr_in($port, INADDR_ANY); 

# bind to a port, then listen 
bind(SERVER, $paddr) or die "bind: $!\n"; 
listen(SERVER, SOMAXCONN) or die "listen: $!\n"; 
print "SERVER started on port $port.\n"; 

# accepting a connection 
my $client_addr; 
while ($client_addr = accept(CLIENT, SERVER)) 
{ 

    # find out who connected
    my ($client_port, $client_ip) = sockaddr_in($client_addr); 
    my $client_ipnum = inet_ntoa($client_ip); 
    my $client_host = gethostbyaddr($client_ip, AF_INET); 

    # print who has connected 
    print "got a connection from: $client_host","[$client_ipnum] "; 
	
	my $datagram = "";
	recv(CLIENT, $datagram, 10, 0);

    # getting time since 1970 in seconds 
	my $time = time();
	# Packing data as 32 bit binary to send
	my $data = pack("l", $time);
	send(CLIENT, $data, 4);
    close CLIENT; 
} 