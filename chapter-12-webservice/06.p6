sub dispatcher(&body) {
    my @*CASES;
    body();
    my @cases = @*CASES;
    return sub (Mu $x) {
        for @cases -> &case {
            if $x ~~ &case.signature.params[0].type {
                return case($x)
            }
        }
        die "No case matched $x";
    }
}

sub on(&case) {
    die "Called on() outside a dispatcher block"
        unless defined @*CASES;

    unless &case.signature.params == 1 {
        die "on() expects a block with exactly one parameter"
    }
    @*CASES.push: &case;
}

my &d = dispatcher {
    on -> Str $x { say "String $x" }
    on -> Date $x { say "Date $x" }
}

d(Date.new('2020-12-24'));
d("a test");
