#!perl -T

use strict;
use warnings;

use Test::More tests => 1;

BEGIN
{
    use_ok('Clone::Choose') || BAIL_OUT "Couldn't load Clone::Choose";
}

diag("Testing Clone::Choose $Clone::Choose::VERSION, Perl $], $^X");
