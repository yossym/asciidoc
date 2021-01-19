#!/bin/perl -s

=head1 NAME

Z:\Documsnts\asciidoc\asciidoc\perl\echo_client

=head1 SYNOPSIS

Z:\Documsnts\asciidoc\asciidoc\perl\echo_client

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

# クライアント
# 1. ソケットの作成
my $sock;
socket($sock, PF_INET, SOCK_STREAM, getprotobyname('tcp' ))
  or die "Cannot create socket: $!";

# 2. ソケット情報の作成

# 接続先のホスト名
my $remote_host = 'localhost';
my $packed_remote_host = inet_aton($remote_host)
  or die "Cannot pack $remote_host: $!";

# 接続先のポート番号
my $remote_port = 9000;

# ホスト名とポート番号をパック
my $sock_addr = sockaddr_in($remote_port, $packed_remote_host)
  or die "Cannot pack $remote_host:$remote_port: $!";

# 3. ソケットを使って接続
connect($sock, $sock_addr)
  or die "Cannot connect $remote_host:$remote_port: $!";

# 4. データの書き込み
# 書き込みバッファリングをしない。
my $old_handle = select $sock;
$| = 1; 
select $old_handle;

print $sock "Hello";

# 書き込みを終了する
shutdown $sock, 1;

# 5. データの読み込み
while (my $line = <$sock>) {
  print $line;
}

# 6. ソケットを閉じる
close $sock;
