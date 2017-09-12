package Clone::Choose;

use strict;
use warnings;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

=head1 NAME

Clone::Choose - Choose appropriate clone utility

=cut

$VERSION = '0.001';

my @BACKENDS = (
    Clone       => "clone",
    Storable    => "dclone",
    "Clone::PP" => "clone",
);

BEGIN
{
    eval "use Module::Runtime (); 1;" and Module::Runtime->import("use_module");    ## no critic
    __PACKAGE__->can("use_module") or *use_module = sub {
        my $pkg = shift;
        eval "use $pkg";                                                            ## no critic
        $@ and die $@;                                                              ## no critic
        1;
    };
}

sub import
{
    my $me       = shift;
    my $tgt      = caller(1);
    my @backends = @BACKENDS;

    # TODO fetch version/tags/function-names ...

    # assume ('clone') - more details later ...
    while (my ($pkg, $rout) = splice @backends, 0, 2)
    {
        eval { use_module($pkg); 1; } or next;

        my $fn = $pkg->can($rout);
        $fn or next;

        no strict 'refs';
        *{"$tgt\::clone"} = $fn;
        last;
    }
}

# TODO cleanup namespace (use_module)

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 EXPORTS

=head2 clone

=cut

=head1 AUTHOR

Jens Rehsack, C<< <rehsack at cpan.org> >>
Stefan Hermes, C<< <hermes at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-Clone-Choose at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Clone-Choose>.
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

  perldoc Clone::Choose

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Clone-Choose>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Clone-Choose>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Clone-Choose>

=item * Search CPAN

L<http://search.cpan.org/dist/Clone-Choose/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2017 Jens Rehsack
Copyright 2017 Stefan Hermes

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 SEE ALSO

L<Clone>, L<Clone::PP>, L<Storable>

=cut

1;
