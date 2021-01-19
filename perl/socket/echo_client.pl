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
# ���݂̓��t�E�������A�擾
# my $datetime = strftime("%a, %d %b %Y %H:%M:%S %z", localtime());



use strict;
use warnings;
use Socket;

# �N���C�A���g
# 1. �\�P�b�g�̍쐬
my $sock;
socket($sock, PF_INET, SOCK_STREAM, getprotobyname('tcp' ))
  or die "Cannot create socket: $!";

# 2. �\�P�b�g���̍쐬

# �ڑ���̃z�X�g��
my $remote_host = 'localhost';
my $packed_remote_host = inet_aton($remote_host)
  or die "Cannot pack $remote_host: $!";

# �ڑ���̃|�[�g�ԍ�
my $remote_port = 9000;

# �z�X�g���ƃ|�[�g�ԍ����p�b�N
my $sock_addr = sockaddr_in($remote_port, $packed_remote_host)
  or die "Cannot pack $remote_host:$remote_port: $!";

# 3. �\�P�b�g���g���Đڑ�
connect($sock, $sock_addr)
  or die "Cannot connect $remote_host:$remote_port: $!";

# 4. �f�[�^�̏�������
# �������݃o�b�t�@�����O�����Ȃ��B
my $old_handle = select $sock;
$| = 1; 
select $old_handle;

print $sock "Hello";

# �������݂��I������
shutdown $sock, 1;

# 5. �f�[�^�̓ǂݍ���
while (my $line = <$sock>) {
  print $line;
}

# 6. �\�P�b�g�����
close $sock;
