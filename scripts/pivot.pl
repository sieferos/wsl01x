#!/usr/bin/env perl -w

# /*
# * pivot.pl
# * sieferos: 12/05/2019
# *
# * cat ${HOME}/Daniel/TNPS/__idx/DataExtract/201811.1973048.csv | ${HOME}/github/sieferos/wsl01x/scripts/flattener.pl | ${HOME}/github/sieferos/wsl01x/scripts/pivot.pl 2>&1
# *
# */

require 5.000;
use strict;

use Data::Dumper;
use Text::CSV;

my $debug = 0;
my $silent = 0;
my $check = 0;
my $separator = ',';
my $quote_char = '"';

use constant {
    NULL => '-null-',
};

sub trim { my @out = @_; for (@out) { s/^\s+//; s/\s+$//; } return wantarray ? @out : $out[0]; } # trim
sub uppercase { my @out = @_; for (@out) { s/([a-z]+)/uc($1)/eg; } return wantarray ? @out : $out[0]; } # uppercase

foreach my $a (@ARGV) {
    if ($a =~ /^\-+(DE?B?U?G?)$/i) { $debug = 1; next; }
    if ($a =~ /^\-+(SI?L?E?N?T?)$/i) { $silent = 1; next; }
    if ($a =~ /^\-+(SEM?I?C?O?L?O?N?)$/i) { $separator = ';'; next; }
}

my (@INDEX, $PIVOT);

foreach my $l (trim (<STDIN>)) {
    next if ($l eq '');
    if (my ($piv, $P) = ($l =~ /^pivot\@([^\[]+)\[([^\]]+)\]/)) {
        print sprintf ("( @ ) P [ %s ] ( %s )\n", $piv, $P) if (0 and $debug and not $silent);
        push (@{$PIVOT->{$piv}}, $P);
        next;
    }
    print sprintf ("( @ ) C [ %s ]\n", $l) if (0 and $debug and not $silent);
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

my ($buffer, $CNT);

foreach my $l (@INDEX) {
    if ($csv->parse($l)) {
        my ($USER_ID, $visitorstatus, $clientstatus, $clientdebt, $prepaid_postpaid, $navigationspeed, $purchasedpackages, $loginprofile, $ERROR, $C) = $csv->fields();

        next if ($USER_ID eq "USER_ID");

        my $KEY = join ($separator, ( $USER_ID, $visitorstatus, $clientstatus, $prepaid_postpaid, $purchasedpackages, $loginprofile ));

        $CNT->{$KEY}++;

        my $VAL = join ($separator, ( $clientdebt, $navigationspeed, $ERROR ));

        print sprintf ("( @ ) L [ %s ] ( %s )\n", $KEY, $VAL) if (0 and $debug and not $silent);

        $buffer->{$KEY}->{'clientdebt'}->{$clientdebt}++ if ($clientdebt ne NULL);
        $buffer->{$KEY}->{'navigationspeed'}->{$navigationspeed}++ if ($navigationspeed ne NULL);
        $buffer->{$KEY}->{'ERROR'}->{$ERROR}++ if ($ERROR ne NULL);
    }
}

# print Dumper($buffer);

my @flattenkeys = qw( clientdebt navigationspeed ERROR );
print sprintf ("%s%s%s%s%s\n",
  'USER_ID,visitorstatus,clientstatus,prepaid_postpaid,purchasedpackages,loginprofile',
  $separator,
  join ($separator, @flattenkeys),
  $separator,
  'C'
);

foreach my $KEY (sort keys %{$buffer}) {
  my @R;
    foreach my $W (@flattenkeys) {
        my @result;
        if (defined ($buffer->{$KEY}->{$W})) {
            foreach my $fv (sort keys %{$buffer->{$KEY}->{$W}}) {
                push (@result, $fv);
            }
        }
        else { push (@result, 'False'); }
        my $r = join ('|', sort @result);
        print sprintf ("( @ ) R [ %s: %s ]\n", $W, $r) if (1 and $debug and not $silent);
        push (@R, $r)
    }
    print sprintf ("%s%s%s%s%d\n",
        $KEY,
        $separator,
        join ($separator, @R),
        $separator,
        $CNT->{$KEY} || 0
    );
}
