#!/bin/perl -s

=head1 NAME

ZeroNear

=head1 SYNOPSIS

ZeroNear

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
$OFS = ",";


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

my@array = ();
while ( my $line = <STDIN>) {
    chomp($line);
    # say $line;
    push @array , $line;
}
my $low_count = 1;
my $low_value = 65535;
my $i = $low_count;

foreach my $value (@array) {
    # say $value, abs( $value ),$low_value;
    if ($value != 0) {

        if ( abs(  $low_value) > abs($value)    ) {
            $low_value  = $value;
            $low_count = $i;
        }
    }
    $i += 1;
}
say $low_count, $low_value ;

