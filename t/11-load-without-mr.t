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

SCOPE:
{
    use FindBin qw($Bin);
    local @INC;
    push @INC, "$Bin/lib";
    local @Clone::Choose::BACKENDS = ("Module_With_Wrong_Name" => "clone");
    eval { Clone::Choose->import(":Module_With_Wrong_Name", "clone"); };
    my $e = $@;
    like($e, qr/Cannot find an apropriate clone/, "Cannot load Module_With_Wrong_Name");
}

done_testing;
