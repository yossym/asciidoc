#!/bin/perl -s

=head1 NAME

hanoi

=head1 SYNOPSIS

hanoi

=head1 DESCRIPTION

=cut

use strict;
use warnings;

use feature qw( switch say );
# use feature ':5.10';
# say $msg;

use autodie;
use  English;   # for use AWK varible
# $ORS = "\n";
# $OFS = ",";


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

use Data::Dumper;
#
## データをダンプ
#my $dump_string = Dumper $data;

# while ( my $line = <STDIN>) {
#     chomp($line);
#     say $line;
# }

sub hanoi {

    my  ( $n, $a, $b, $c) = @_;

    if ($n ==  0 ) {
        return;
    }

    hanoi($n-1, $a, $c, $b);
    say qq(   $a -> $b);
    # printf("%4s -> %4s \n", a, b);
    hanoi($n-1, $c, $b, $a);
}

sub main{
    my $n = 3;
# int n = DISK_NUM;
    my $a="LEFT";
    my $b="CENTER";
    my $c = "RIGHT";
    hanoi($n, $a,$b,$c);
    # return 0;
}
main;

