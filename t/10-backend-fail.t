#!perl

use strict;
use warnings;
use Test::More;

eval "use Module::Runtime;";
$@ and plan skip_all => "Module::Runtime not found. Skipping test.";
Module::Runtime->import("use_module");

SCOPE:
{
    local $ENV{CLONE_CHOOSE_PREFERRED_BACKEND} = "JSON";
    eval { use_module("Clone::Choose")->get_backends(":JSON"); };
    my $e = $@;
    like($e, qr/not found/, "Favourite not found");
}

SCOPE:
{
    local $ENV{CLONE_CHOOSE_PREFERRED_BACKEND} = "List::Util";
    eval { use_module("Clone::Choose")->backend() };
    my $e = $@;
    like($e, qr/not found/, "Cannot find an apropriate clone");
}

done_testing;
