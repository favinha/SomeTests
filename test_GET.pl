#! /usr/bin/perl -w

use strict;
use warnings;
use Test::More;

use HTTP::Request;
use HTTP::Headers;
use LWP::UserAgent;
use Data::Dumper;
use JSON;
use JSON::Schema;

#### The server name where all the informatiuon is
my $server = 'http://randomserver.com';
my $json = JSON->new();


my $struct = {
    name => 'test',
    devs => [
        {
            group => 'testa',
            devs  => [
                {
                    uuid => 'a'
                },
                {
                    uuid => 'b'
                }
            ]
        }
    ]
};

# - Test #1 - Test if the server is there
my $ua = LWP::UserAgent->new;
my $response = $ua->get($server); 

is($response->is_success, '1', "The server exists");


# - Test #2 - Test the GET

# set the header
my $header = HTTP::Headers->new;
$header->header('Content-Type' => 'application/json');

# set the request
my $request = HTTP::Request->new('GET', $server.'/do/task', $header);

# do the request
my $content = $ua->request($request)->content;

# Should we validate the response json before?

#decode the message
my $json_answer = from_json($content);

# the answer should be equal to the struct
#test if both structs are equal
is_deeply($json_answer, $struct, "The structs are the same");


# - Test #3 - Test again, but send a body

# set the request
my $body = {name => 'testpool', action => 'create'};
my $json_body = to_json($body);

my $request = HTTP::Request->new('GET', $server.'/do/task', $header, $json_body);
#decode the message
my $json_answer = from_json($content);

# the answer should be equal to the struct
#test if both structs are equal
is_deeply($json_answer, $struct, "The structs are the same");


done_testing;


1;
