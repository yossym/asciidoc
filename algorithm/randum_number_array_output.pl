#!/bin/perl 

=head1 NAME

randum_number_array

=head1 SYNOPSIS

randum_number_array

=head1 DESCRIPTION

=cut

use strict;
use warnings;
#
use feature qw( switch say );
# # use feature ':5.10';
#
use autodie;
use  English;   # for use AWK varible
$ORS = "\n";
$OFS = "\t";
#
#
use utf8;
  # if ms-dos
  binmode STDIN, ':encoding(cp932)';
  binmode STDOUT, ':encoding(cp932)';
  binmode STDERR, ':encoding(cp932)';
  # if linux
  #binmode STDIN,  ":utf8";
  #binmode STDOUT, ":utf8";
  #binmode STDERR, ":utf8";
#
# # import
use Data::Lock qw/dlock dunlock/;
#
use POSIX qw(strftime);
# # 現在の日付・時刻を、取得
# # my $datetime = strftime("%a, %d %b %Y %H:%M:%S %z", localtime());

use Getopt::Long ;
# use Getopt::Long  'GetOptions';

     # GetOptions("text=s" => \$text, "opt" => \$opt);
     #
     # print "text = '$text'\n";
     # print "option = $opt\n";


my $number = 0;
my $count = 100;
my $help = 0;
my $integral = 0;

GetOptions( 'help' => \$help, 
            'number' => \$number, 
            "count=i" => \$count, 
            'integeral' => \$integral);

if ( $help == 1 ) {
    say qq(--count 100 --number --help);
    say qq( --count : max count; ;); 
    say qq( --number : line number;) ;
    say qq( --help; );
}

sub natural_number_random {
    my $i = 1;
    my $pre_count = rand($count);
    my $post_count = $count - 2 - $pre_count;

    for ( my $i = 0 ; $i < $pre_count; $i++ ) {
        if ( $number == 1  ) {
            say $i,rand($count) - rand($count);
            $i += 1;
        } else {
            say rand($count) - rand($count);
        }
    }
    if ( $number == 1 ) {
        say $i, 0.0;
        $i += 1;
    } else {
        say 0.0;
    }
    for (my $i = 0 ; $i < $post_count; $i++) {
        if ( $number == 1  ) {
            say $i,rand($count) - rand($count);
            $i += 1;
        } else {
            say rand($count) - rand($count);
        }
    }




}

sub integra_number_random {
    my $count = $_;

    for ( my $i = 0 ; $i < $count; $i++ ) {
        say rand( $count ) ;
    }

}

sub main {

    if ( $help == 1 ) {
        usage();
    }

    if ( $integral == 1) {
        integra_number_random();

    } else {
        natural_number_random();
    }


}

main

