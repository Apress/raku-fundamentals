#!/usr/bin/env raku

#| Convert timestamp to ISO date
multi sub MAIN(Int \timestamp) {
    sub formatter($_) {
        sprintf '%04d-%02d-%02d %02d:%02d:%02d',
                .year, .month,  .day,
                .hour, .minute, .second,
    }
    given DateTime.new(+timestamp, :&formatter) {
        when .Date.DateTime == $_ { say .Date }
        default { .say }
    }
}

#| Convert ISO date to timestamp
multi sub MAIN(Str $date where { try Date.new($_) }, Str $time?) {
    my $d = Date.new($date);
    if $time {
        my ( $hour, $minute, $second ) = $time.split(':');
        say DateTime.new(date => $d, :$hour, :$minute, :$second).posix;
    }
    else {
        say $d.DateTime.posix;
    }
}

