use strict;
use warnings;

foreach my $line ( <STDIN> ) {
    # chomp( $line );
    ### 02/11/2018 17:19,Guest
    # print "$line\n";
    $line =~ s/(\d{2})\/(\d{2})\/(\d{4})\s(\d{2})\:(\d{2})/$3\/$2\/$1 $4:$5:00.000/g;
    print $line;
}
