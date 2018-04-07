package Sandbox::Tumble;

use strict;
use warnings;

use Cwd qw();
use File::Spec qw();
use Test::WriteVariants 0.014;

use FindBin qw();

$| = 1;

sub tumble
{
    my ($class, $output_dir) = @_;

    my $template_dir = Cwd::abs_path(File::Spec->catdir($FindBin::RealBin, "t"));
    my $test_writer = Test::WriteVariants->new();
    $test_writer->allow_dir_overwrite(1);
    $test_writer->allow_file_overwrite(1);

    $test_writer->write_test_variants(
        input_tests => $test_writer->find_input_inline_tests(
            search_patterns => ["*.t"],
            search_dirs     => ["t/inline"],
        ),
        variant_providers => ["CC::Clones", "CC::MR"],
        output_dir        => $output_dir,
    );
}

package CC::Clones::TestVariants;

use strict;
use warnings;

sub provider
{
    my ($self, $path, $context, $tests, $variants) = @_;
    my $strict   = $context->new_module_use(strict   => [qw(subs vars refs)]);
    my $warnings = $context->new_module_use(warnings => ['all']);

    $variants->{Auto} = $context->new($warnings, $strict);

    $variants->{Clone} = $context->new(
        $context->new_env_var(
            CLONE_CHOOSE_PREFERRED_BACKEND => "Clone",
        ),
        $warnings,
        $strict,
    );
    $variants->{Storable} = $context->new(
        $context->new_env_var(
            CLONE_CHOOSE_PREFERRED_BACKEND => "Storable",
        ),
        $warnings,
        $strict,
    );
    $variants->{ClonePP} = $context->new(
        $context->new_env_var(
            CLONE_CHOOSE_PREFERRED_BACKEND => "Clone::PP",
        ),
        $warnings,
        $strict,
    );
}

package CC::MR::TestVariants;

use strict;
use warnings;

sub provider
{
    my ($self, $path, $context, $tests, $variants) = @_;

    $variants->{NoMR} = $context->new_module_use(
        "Test::Without::Module" => [qw(Module::Runtime)],
    );
    $variants->{MR} = $context->new();
}

1;
