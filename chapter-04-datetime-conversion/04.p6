#!/usr/bin/env raku
sub MAIN(Int $timestamp) {
    my $dt = DateTime.new(+$timestamp);
    if all($dt.hour, $dt.minute, $dt.second) == 0 {
        say $dt.Date;
    }
    else {
        say $dt;
    }
}
