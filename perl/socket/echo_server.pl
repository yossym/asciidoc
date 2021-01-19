#!/bin/perl -s

=head1 NAME

Z:\Documsnts\asciidoc\asciidoc\perl\echo_server

=head1 SYNOPSIS

Z:\Documsnts\asciidoc\asciidoc\perl\echo_server

=head1 DESCRIPTION

=cut

use strict;
use warnings;

use feature qw( switch say );
# use feature ':5.10';

use autodie;

use utf8;
  # if ms-dos
  binmode STDIN, ':encoding(cp932)';
  binmode STDOUT, ':encoding(cp932)';
  binmode STDERR, ':encoding(cp932)';
  # if linux
  #binmode STDIN,  ":utf8";
  #binmode STDOUT, ":utf8";
  #binmode STDERR, ":utf8";

# import
use Data::Lock qw/dlock dunlock/;

use POSIX qw(strftime);
# 現在の日付・時刻を、取得
# my $datetime = strftime("%a, %d %b %Y %H:%M:%S %z", localtime());


use strict;
use warnings;
use Socket;

# サーバ

# 1. 受付用ソケットの作成

my $sock_receive;
socket($sock_receive, PF_INET, SOCK_STREAM, getprotobyname( 'tcp' ))
  or die "Cannot create socket: $!";

# 2. 受付用ソケット情報の作成
my $local_port = 9000;

my $pack_addr = sockaddr_in($local_port, INADDR_ANY);

# 3. 受付用ソケットと受付用ソケット情報を結びつける
bind($sock_receive, $pack_addr)
  or die "Cannot bind: $!";

# 4. 接続を受け付ける準備をする。
listen($sock_receive, SOMAXCONN)
  or die "Cannot listen: $!";

# 5. 接続を受け付けて応答する。
my $sock_client; # クライアントとの通信用のソケット

while (accept( $sock_client, $sock_receive )) {
  my $content;
  
  # クライアントからのデータの読み込み
  while (my $line = <$sock_client>) {
    $content .= $line;
  }
  
  # クライアントへのデータの書き込み
  print $sock_client "echo: $content";
  close $sock_client;
}
