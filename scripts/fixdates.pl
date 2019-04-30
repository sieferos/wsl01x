#!/usr/bin/env perl

use strict;
use warnings;

foreach my $line ( <STDIN> ) {
    # chomp( $line );
    # print "$line\n";
    ### 02/11/2018 17:19,Guest
    # $line =~ s/(\d{2})\/(\d{2})\/(\d{4})\s(\d{2})\:(\d{2})/$3\/$2\/$1 $4:$5:00.000/g;
    $line =~ s/(\d{2})\/(\d{2})\/(\d{4})\s(\d{2})\:(\d{2})/$3\/$2\/$1/g;
    ### 2018/11/12 20:18:00.000
    $line =~ s/(\d{4})\/(\d{2})\/(\d{2})\s\d{2}\:\d{2}:\d{2}\.\d+/$1\/$2\/$3/g;
    ### "November 30, 2018"
    if (my ($Month, $Day, $Year) = ($line =~ /\"([A-Z]+)\s+(\d+)\,\s*(\d+)\"/i)) {
        ### LC_TIME=en_GB.UTF-8 locale mon
        ### January;February;March;April;May;June;July;August;September;October;November;December
        $Month =~ s/January/01/i;
        $Month =~ s/February/02/i;
        $Month =~ s/March/03/i;
        $Month =~ s/April/04/i;
        $Month =~ s/May/05/i;
        $Month =~ s/June/06/i;
        $Month =~ s/July/07/i;
        $Month =~ s/August/08/i;
        $Month =~ s/September/09/i;
        $Month =~ s/October/10/i;
        $Month =~ s/November/11/i;
        $Month =~ s/December/12/i;
        $Month =~ s/^[A-Z]+$/00/i;
        my $datetime = sprintf ("%04d/%s/%02d", $Year, $Month, $Day);
        ### print sprintf ("%s\n", $datetime);
        $line =~ s/\"(\w+)\s+(\d+)\,\s*(\d+)\"/$datetime/gi;
    }
    print $line;
}
