#!perl

use strict;
use warnings;
use Test::More;

eval "use Module::Runtime;";
$@ and plan skip_all => "Module::Runtime not found. Skipping test.";
Module::Runtime->import("use_module");

SCOPE:
{
    ok(!use_module("Clone::Choose")->can("no_clone"));
}

SCOPE:
{
    local $ENV{CLONE_CHOOSE_PREFERRED_BACKEND} = "List::Util";
    eval { use_module("Clone::Choose")->can("clone") };
    my $e = $@;
    like($e, qr/not found/, "Cannot find an apropriate clone");
}

done_testing;
