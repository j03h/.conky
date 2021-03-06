#!/usr/bin/perl

# gimap.pl by gxmsgx
# description: get the count of unread messages on imap

use strict;
use Mail::IMAPClient;
use IO::Socket::SSL;
use Encode qw(decode);

my $username = 'imap@email.com'; 
my $password = 'password'; 

my $socket = IO::Socket::SSL->new(
  PeerAddr => 'imap.gmail.com',
  PeerPort => 993
 )
 or die "socket(): $@";

my $client = Mail::IMAPClient->new(
  Socket   => $socket,
  User     => $username,
  Password => $password,
 )
 or die "new(): $@";

if ($client->IsAuthenticated()) {
   my $msgct;
   
   

   $client->select("INBOX");
   
   $msgct = $client->unseen_count||'0';
   my @msgs = $client->messages;
   print "$msgct\n";
	foreach my $msg (@msgs){
	   print decode("MIME-Header", $client->subject($msg))."\n";
	}
	print "\n";
   
}

$client->logout();
