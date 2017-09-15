#!perl

use strict;
use warnings;
use Test::More;

eval "use Clone;";
$@ and plan skip_all => "No Clone found. Can't prove load successfull with :Clone.";

use_ok("Clone::Choose", qw(:Clone)) || BAIL_OUT "Couldn't use Clone::Choose qw(:Clone).";

done_testing;
