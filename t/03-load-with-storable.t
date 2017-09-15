#! perl

use strict;
use warnings;
use Test::More;

eval "use Storable;";
$@ and plan skip_all => "No Storable found. Can't prove load successfully with :Storable.";

use_ok("Clone::Choose", qw(:Storable)) || BAIL_OUT "Couldn't use Clone::Choose qw(:Storable).";

done_testing;
