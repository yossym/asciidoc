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
# ���݂̓��t�E�������A�擾
# my $datetime = strftime("%a, %d %b %Y %H:%M:%S %z", localtime());


use strict;
use warnings;
use Socket;

# �T�[�o

# 1. ��t�p�\�P�b�g�̍쐬

my $sock_receive;
socket($sock_receive, PF_INET, SOCK_STREAM, getprotobyname( 'tcp' ))
  or die "Cannot create socket: $!";

# 2. ��t�p�\�P�b�g���̍쐬
my $local_port = 9000;

my $pack_addr = sockaddr_in($local_port, INADDR_ANY);

# 3. ��t�p�\�P�b�g�Ǝ�t�p�\�P�b�g�������т���
bind($sock_receive, $pack_addr)
  or die "Cannot bind: $!";

# 4. �ڑ����󂯕t���鏀��������B
listen($sock_receive, SOMAXCONN)
  or die "Cannot listen: $!";

# 5. �ڑ����󂯕t���ĉ�������B
my $sock_client; # �N���C�A���g�Ƃ̒ʐM�p�̃\�P�b�g

while (accept( $sock_client, $sock_receive )) {
  my $content;
  
  # �N���C�A���g����̃f�[�^�̓ǂݍ���
  while (my $line = <$sock_client>) {
    $content .= $line;
  }
  
  # �N���C�A���g�ւ̃f�[�^�̏�������
  print $sock_client "echo: $content";
  close $sock_client;
}
