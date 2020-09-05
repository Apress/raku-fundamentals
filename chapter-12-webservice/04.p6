use Cro::HTTP::Router;
use Cro::HTTP::Server;

my $date-re = token { 
    \d**4 '-' \d**2 '-' \d** 2 # date part YYYY-MM-DD
    [
        ' '
         \d**2 ':' \d**2 ':' \d**2 # time
    ]?
}

sub routes() {
    return route {
        get -> 'datetime', Int $timestamp {
            my $dt = DateTime.new(+$timestamp);
            $dt = $dt.Date
                if $dt.Date.DateTime == $dt;
            content 'application/json', {
                input => $timestamp,
                result => $dt.Str,
            }
        }
        get -> 'datetime', Str $date_spec where $date-re {
            my ($date_str, $time_str) = $date_spec.split(' ');
            my $date = Date.new($date_str);
            my $datetime;
            if $time_str {
                my ( $hour, $minute, $second ) = $time_str.split(':');
                $datetime = DateTime.new( :$date, :$hour, :$minute, :$second);
            }
            else {
                $datetime = $date.DateTime;
            }
            content "application/json", {
                input => $date_spec,
                result => $datetime.posix,
            }
        }
    }
}

multi sub MAIN(Int :$port = 8080, :$host = '0.0.0.0') {
    my Cro::Service $service = Cro::HTTP::Server.new(
        :$host
        :$port,
        application => routes(),
    );
    $service.start;
    say "Application started on port $port";

    react whenever signal(SIGINT) { $service.stop; done; }
}

multi sub MAIN('test') {
    use Cro::HTTP::Test;
    use Test;

    test-service routes(), {
        test get('/datetime/1578135634'),
            status => 200,
            json => {
                result => "2020-01-04T11:00:34Z",
                input => 1578135634 ,
            };

        test get('/datetime/2020-01-04%2011:00:34'),
            status => 200,
            json => {
                input => '2020-01-04 11:00:34',
                result => 1578135634,
            };
    }

    done-testing;
}
