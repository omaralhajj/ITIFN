#! /usr/bin/perl -w
# udpserver.pl
#--------------------

use IO::Socket::INET;

# port either specified as arg or defaults to 7890
my $port = shift || 7890;
# grab a port on this machine
my $paddr = sockaddr_in($port, INADDR_ANY);

# creating a listening socket, now udp i guess
my $socket = new IO::Socket::INET (
    $paddr,
    $port,
    Proto => 'udp',
    Listen => 5,
    Reuse => 1
);
die "cannot create socket $!\n" unless $socket;
print "server waiting for client connection on port $port\n";
 
while(1)
{
    # waiting for a new client connection
    my $client_socket = $socket->accept();
 
    # get information about a newly connected client
    my $client_address = $client_socket->peerhost();
    my $client_port = $client_socket->peerport();
    print "connection from $client_address:$client_port\n";
	
	# receiving datagram from client because this is udp
	my $datagram = "";
	client_socket->recv($datagram, 100);
	# print whether empty or not
	print "$datagram";
 
    # getting seconds since 1970
	my $time = time();
	# Packing data as 32 bit binary to send. Packing as long because time() returns a long
	my $data = pack("l", $time);
	# sending data to client
    $client_socket->send($data);
 
    # notify client that response has been sent
    shutdown($client_socket, 1);
}
 
$socket->close();