use Cro::HTTP::Router;
use Cro::HTTP::Server;

my $date-re = token { 
    \d**4 '-' \d**2 '-' \d** 2 # date part YYYY-MM-DD
    [
        ' '
         \d**2 ':' \d**2 ':' \d**2 # time
    ]?
}

my $application = route {
    get -> 'datetime', Int $timestamp {
        my $dt = DateTime.new(+$timestamp);
        $dt = $dt.Date
            if $dt.Date.DateTime == $dt;
        content 'text/plain', "$dt\n";
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
        content "text/plain", $datetime.posix ~ "\n";
    }
}
my $port = 8080;
my Cro::Service $service = Cro::HTTP::Server.new(
    :host('0.0.0.0'),
    :$port,
    :$application
);

$service.start;
say "Application started on port $port";
react whenever signal(SIGINT) { $service.stop; exit; }
