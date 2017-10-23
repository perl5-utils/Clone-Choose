#!perl

use strict;
use warnings;

use Test::More;
use Test::PerlTidy;

run_tests(
    perltidyrc => '.perltidyrc',
    exclude    => ['t/Clone/', 't/Storable/', 't/ClonePP/'],
);
