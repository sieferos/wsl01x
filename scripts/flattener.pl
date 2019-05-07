#!/usr/bin/env perl -w

# /*
# * flattener.pl
# * sieferos: 07/05/2019
# *
# * cat ${HOME}/Daniel/TNPS/__idx/DataExtract/201811.15563076.csv | ${HOME}/github/sieferos/wsl01x/scripts/flattener.pl 2>&1
# * cat ${HOME}/Daniel/TNPS/__idx/DataExtract/201811.1973048.csv | ${HOME}/github/sieferos/wsl01x/scripts/flattener.pl 2>&1

require 5.000;
use strict;

use Data::Dumper;
use Text::CSV;

my $debug = 0;
my $silent = 0;
my $check = 0;
my $separator = ',';
my $quote_char = '"';

my $vendor;

sub trim { my @out = @_; for (@out) { s/^\s+//; s/\s+$//; } return wantarray ? @out : $out[0]; } # trim
sub uppercase { my @out = @_; for (@out) { s/([a-z]+)/uc($1)/eg; } return wantarray ? @out : $out[0]; } # uppercase

foreach my $a (@ARGV) {
    if ($a =~ /^\-+(DE?B?U?G?)$/i) { $debug = 1; next; }
    if ($a =~ /^\-+(SI?L?E?N?T?)$/i) { $silent = 1; next; }
}

my (@INDEX);

foreach my $l (trim (<STDIN>)) {
    print sprintf ("( @ ) CSV [ %s ]\n", $l) if (1 and $debug and not $silent);
    ### USER_ID,visitorstatus,clientstatus,clientdebt,prepaid_postpaid,navigationspeed,purchasedpackages,loginprofile,ERROR
    ### 15563076,particular postpago,cliente activo,-null-,particular postpago,-null-,one,completo,-null- ]
    ### 15563076,particular postpago,cliente activo,-null-,particular postpago,-null-,one,completo,True ]
    push (@INDEX, $l);
    next;
}

my $csv = Text::CSV->new ({
    decode_utf8 => 0,
    binary => 1,
    auto_diag => 1,
    # blank_is_undef => 1,
    # empty_is_undef => 1,
    allow_whitespace => 1,
    allow_loose_escapes => 0,
    quote_char => $quote_char,
    # escape_char => undef,
    sep_char => ','
}) if @INDEX;

foreach my $l (@INDEX) {
    if ($csv->parse($l)) {
        my ($USER_ID, $visitorstatus, $clientstatus, $clientdebt, $prepaid_postpaid, $navigationspeed, $purchasedpackages, $loginprofile, $ERROR) = $csv->fields();

        next if ($USER_ID eq "USER_ID");

        my $KEY = join ("|", ( $USER_ID, $visitorstatus, $prepaid_postpaid, $purchasedpackages, $loginprofile ));
        my $VAL = join ("|", ( $clientstatus, $clientdebt, $navigationspeed, $ERROR ));

        print sprintf ("( @ ) L [ %s ] ( %s )\n", $KEY, $VAL) if ($debug and not $silent);
    }
}
