#!/usr/bin/env raku
sub MAIN(Int $timestamp) {
    my $dt = DateTime.new(+$timestamp);
    if $dt.Date.DateTime == $dt {
        say $dt.Date;
    }
    else {
        say $dt;
    }
}
