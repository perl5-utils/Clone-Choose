#!perl

use strict;
use warnings;
use Test::More;

SCOPE:
{
    local $ENV{CLONE_CHOOSE_NO_MODULE_RUNTIME} = 1;
    use_ok('Clone::Choose') || BAIL_OUT "Couldn't load Clone::Choose without Module::Runtime";
}

done_testing;
