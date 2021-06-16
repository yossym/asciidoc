#!/bin/perl -s

=head1 NAME

sorted

=head1 SYNOPSIS

sorted

=head1 DESCRIPTION

=cut

use strict;
use warnings;

use feature qw( switch say );
# use feature ':5.10';
# say $msg;

use autodie;
use  English;   # for use AWK varible
$ORS = "\n";
# $OFS = ",";


use utf8;
  # if ms-dos
  binmode STDIN,  ':encoding(cp932)';
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

# my @words = ();
# while ( my $line = <STDIN>) {
#     chomp($line);
#     push @words,$line;
# }



use Getopt::Long 'GetOptions';

my $type = 'quich';

# オプションの処理
GetOptions(
  'type=s'        => \$type
);

my @numbers =();

sub bubbleSort {

    my @numbers = @_;
    my $length = @numbers;

    for ( my $i = 0; $i < $length -1; $i++) {
        for ( my $j = $length -1; $j > $i; $j-- ) {
            if ( $numbers[$j -1] > $numbers[$j] ) {
                my $temp = $numbers[$j -1];
                $numbers[$j-1] = $numbers[$j];
                $numbers[$j] = $temp;
            }
        }
    }
    return @numbers;
}

sub quick_sort{
    my $array = shift;
    if ((scalar @$array) == 0){ return;
    } elsif((scalar @$array) == 1){
        return $array->[0];
    } else {
        my $center = shift(@$array);
        my @right;
        my @left;
        for my $i (@$array){
            if ($center < $i){
                push (@right, $i);
            } else {
                push (@left, $i);
            }
        }
        return (quick_sort(\@left), $center, quick_sort(\@right));
    }
}





sub main {

    while ( my $line = <STDIN>) {
        chomp($line);
        push @numbers,$line;
    }
    if ( $type =~ /bu/  ) {

        @numbers =  bubbleSort( @numbers );
        say Dumper @numbers;
        say "b";
    }

    if ( $type =~ /q/  ) {

        my @result = quick_sort(\@numbers);
        say Dumper @result;
        say "q";
    }

say $type;

}

main

