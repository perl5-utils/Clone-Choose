#!perl

use strict;
use warnings;
use Test::More;

SCOPE:
{
    local $ENV{CLONE_CHOOSE_NO_MODULE_RUNTIME} = 1;
    use_ok('Clone::Choose') || BAIL_OUT "Couldn't load Clone::Choose without Module::Runtime";
}

SCOPE:
{
    local $ENV{CLONE_CHOOSE_NO_MODULE_RUNTIME} = 1;
    local @Clone::Choose::BACKENDS = ("Not_Available_Absolutely_Nonsense" => "clone");
    eval { Clone::Choose->import(":Not_Available_Absolutely_Nonsense", "clone"); };
    my $e = $@;
    like($e, qr/\QCannot find an apropriate clone().\E/, "Loading unloadable package fails correctly.");
}

done_testing;
