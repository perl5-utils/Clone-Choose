#!perl

use strict;
use warnings;

use Test::More;
use Test::CheckManifest;

ok_manifest({filter => [qr/cover_db/]});
