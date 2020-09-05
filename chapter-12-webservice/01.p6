use Cro::HTTP::Router;
use Cro::HTTP::Server;

my $application = route {
    get -> 'datetime', Int $timestamp {
        my $dt = DateTime.new($timestamp);
        $dt = $dt.Date
            if $dt.Date.DateTime == $dt;
        content 'text/plain', "$dt\n";
    }
}
my $port = 8080;
my Cro::Service $service = Cro::HTTP::Server.new(
    :host<0.0.0.0>,
    :$port,
    :$application
);

$service.start;
say "Application started on port $port";
react whenever signal(SIGINT) { $service.stop; done; }
$service.stop;
