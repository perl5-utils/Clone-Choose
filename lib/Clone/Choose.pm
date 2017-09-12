package Clone::Choose;

use strict;
use warnings;
use Carp ();

=head1 NAME

Clone::Choose - Choose appropriate clone utility

=cut

our $VERSION = "0.001";

our @BACKENDS = (
    Clone       => "clone",
    Storable    => "dclone",
    "Clone::PP" => "clone",
);

my $use_m;

BEGIN
{
    unless ($use_m)
    {
        eval "use Module::Runtime (); 1;" and $use_m = Module::Runtime->can("use_module");
        $use_m ||= sub {
            my $pkg = shift;
            eval "use $pkg";
            $@ and die $@;
            1;
        };
    }
}

sub can
{
    my $self     = shift;
    my $name     = shift;
    my @backends = @BACKENDS;

    return __PACKAGE__->SUPER::can($name) unless $name eq "clone";

    my $fn;
    while (my ($pkg, $rout) = splice @backends, 0, 2)
    {
        eval { $use_m->($pkg); 1; } or next;

        $fn = $pkg->can($rout);
        $fn or next;

        last;
    }

    return $fn;
}

sub import
{
    my ($me, @params) = @_;
    my $tgt = caller(1);

    my @B = @BACKENDS;
    local @BACKENDS = @B;

    push @params, "clone" unless grep { /^clone$/ } @params;

    while (my $param = shift @params)
    {
        if ($param =~ m/^\d/)
        {
            # TODO check version
        }
        elsif ($param =~ m/^:(.*)$/)
        {
            my $favourite = $1;
            my %b         = @BACKENDS;
            Carp::croak "$favourite not found" unless $b{$favourite};
            @BACKENDS = ($favourite => $b{$favourite});
        }
        elsif ($param eq "clone")
        {
            my $fn = __PACKAGE__->can("clone");
            $fn or return;

            no strict "refs";
            *{"$tgt\::clone"} = $fn;

            @params and Carp::croak "Parameters left after clone. Please see description.";

            return;
        }
        else
        {
            Carp::croak "$param is not exportable by " . __PACKAGE__;
        }
    }
}

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
