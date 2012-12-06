#! /usr/bin/perl -w

use strict;
use warnings;
use Test::More;

use HTTP::Request;
use HTTP::Headers;
use LWP::UserAgent;
use Data::Dumper;
use JSON;


#### The server name where all the informatiuon is
my $server = 'http://randomserver.com';
my $json = JSON->new();


# - Test #1 - Test if the server is there
my $ua = LWP::UserAgent->new;
my $response = $ua->get($server); 

is($response->is_success, '1', "The server exists");


# - Test #2 - Test the POST
my $body = {name => 'testpool', action => 'create'};
my $json_body = to_json($body);

# set the header
my $header = HTTP::Headers->new;
$header->header('Content-Type' => 'application/json');

# set the request
my $request = HTTP::Request->new('POST', $server.'/do/task', $header, $json_body);

# do the request
my $content = $ua->request($request)->content;
#decode the message
my $json_answer = from_json($content);

# the answer should be true
is($json_answer->{result}, 'true', "It was created");

# - Test #4 - Repeat the post

#lets create again, to see if the answer is now false
$request = HTTP::Request->new('POST', $server.'/do/task', $header, $json_body);
# do the request
$content = $ua->request($request)->content;
#decode the message
$json_answer = from_json($content);

# the answer should be false
is($json_answer->{result}, 'false', "It was NOT created");


# - Test #5 - missing params
delete $body->{action};
$json_body = to_json($body);
#lets create again, to see if the answer is now false
$request = HTTP::Request->new('POST', $server.'/do/task', $header, $json_body);
# do the request
$content = $ua->request($request)->content;
#decode the message
$json_answer = from_json($content);
# the answer should be false
is($json_answer->{result}, 'false', "It was NOT created");



done_testing;


1;
