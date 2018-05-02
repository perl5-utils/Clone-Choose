#!perl

use strict;
use warnings;
use Test::More;

eval "use Module::Runtime;";
$@ and plan skip_all => "Module::Runtime not found. Skipping test.";
Module::Runtime->import("use_module");

SCOPE:
{
    local $ENV{CLONE_CHOOSE_PREFERRED_BACKEND} = "Storable";
    eval { use_module("Clone::Choose")->import(":Clone"); };
    my $e = $@;
    like($e, qr/not equal to imported/, "ENV doesn't match favourite");
}

SCOPE:
{
    eval { use_module("Clone::Choose")->import(":Storable", "clone", "additionalParam"); };
    my $e = $@;
    like($e, qr/Parameters left after clone/, "Parameters left after clone");
}

SCOPE:
{
    eval { use_module("Clone::Choose")->import(":List::Util") };
    my $e = $@;
    like($e, qr/List::Util not found/, "Favourite not found");
}

SCOPE:
{
    no warnings;
    local @Clone::Choose::BACKENDS = ("List::Util" => "clone");
    eval { use_module("Clone::Choose")->import(":List::Util", "clone") };
    my $e = $@;
    like($e, qr/Cannot find an apropriate clone/, "Cannot find an apropriate clone");
    ok(!Clone::Choose->backend());
}

SCOPE:
{
    eval { use_module("Clone::Choose")->import("no_clone"); };
    my $e = $@;
    like($e, qr/no_clone is not exportable by Clone::Choose/, "Unknown function imported");
}

done_testing;
