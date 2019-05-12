#!/usr/bin/env perl -w

# /*
# * flattener.pl
# * sieferos: 07/05/2019
# *
# * cat ${HOME}/Daniel/TNPS/__idx/DataExtract/201811.15563076.csv | ${HOME}/github/sieferos/wsl01x/scripts/flattener.pl 2>&1
# * cat ${HOME}/Daniel/TNPS/__idx/DataExtract/201811.1973048.csv | ${HOME}/github/sieferos/wsl01x/scripts/flattener.pl 2>&1
# *
# * cat ${HOME}/github/sieferos/wsl01x/scripts/cfg/navigation.cfg ${HOME}/Daniel/TNPS/__idx/DataExtract/201811.1973048.csv | ${HOME}/github/sieferos/wsl01x/scripts/flattener.pl 2>&1
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
        print sprintf ("( @ ) P [ %s ] ( %s )\n", $piv, $P) if (1 and $debug and not $silent);
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
        my ($USER_ID, $navigation, $visitorstatus, $clientstatus, $clientdebt, $prepaid_postpaid, $navigationspeed, $purchasedpackages, $loginprofile, $ERROR, $C) = $csv->fields();

        next if ($USER_ID eq 'USER_ID');

        ### WHEN "no logado" THEN "-null-"
        next if ($visitorstatus eq NULL);
        next if ($prepaid_postpaid eq NULL);
        next if ($purchasedpackages eq NULL);
        next if ($loginprofile eq NULL);

        $clientdebt = 'True' if ($clientdebt eq 'si');

        my $KEY = join ($separator, ( $USER_ID, $visitorstatus, $prepaid_postpaid, $purchasedpackages, $loginprofile ));

        $buffer->{$KEY}->{'navigation'}->{$navigation}++ if ($navigation ne NULL);
        $buffer->{$KEY}->{'clientstatus'}->{$clientstatus}++ if ($clientstatus ne NULL);

        $CNT->{$KEY}++;

        my $VAL = join ($separator, ( $clientdebt, $navigationspeed, $ERROR ));

        print sprintf ("( @ ) L [ %s ] ( %s )\n", $KEY, $VAL) if (1 and $debug and not $silent);

        $buffer->{$KEY}->{'clientdebt'}->{$clientdebt}++ if ($clientdebt ne NULL);
        $buffer->{$KEY}->{'navigationspeed'}->{$navigationspeed}++ if ($navigationspeed ne NULL);
        $buffer->{$KEY}->{'ERROR'}->{$ERROR}++ if ($ERROR ne NULL);
    }
}

# print Dumper($buffer);

my @fixedkeys = qw( USER_ID visitorstatus prepaid_postpaid purchasedpackages loginprofile );
my @flattenkeys = qw( clientdebt navigationspeed ERROR );
my @pivotcolsN = sort @{$PIVOT->{'navigation'}} if $PIVOT->{'navigation'};
my @pivotcolsC = sort @{$PIVOT->{'clientstatus'}} if $PIVOT->{'clientstatus'};

# print sprintf ("%s%s%s%s%s%s%s\n",
my $HEADER = sprintf ("%s%s%s%s%s%s%s",
  join ($separator, @fixedkeys),
  $separator, join ($separator, @flattenkeys),
  $separator, join ($separator, @pivotcolsN),
  $separator, join ($separator, @pivotcolsC),
  # $separator, 'C'
);
$HEADER =~ s/$separator$//;
print sprintf ("%s\n", $HEADER);

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
    #
    my @PR;
    foreach my $p (@pivotcolsN) {
        push (@PR, ( defined ($buffer->{$KEY}->{'navigation'}->{$p}) ? '1' : '0' ));
    }
    foreach my $p (@pivotcolsC) {
        push (@PR, ( defined ($buffer->{$KEY}->{'clientstatus'}->{$p}) ? '1' : '0' ));
    }
    #
    # print sprintf ("%s%s%s%s%s%s%d\n",
    print sprintf ("%s%s%s%s%s\n",
        $KEY,
        $separator, join ($separator, @R),
        $separator, join ($separator, @PR),
        # $separator, $CNT->{$KEY} || 0
    );
}
