package Clone::Choose;

use strict;
use warnings;
use Carp ();

our $VERSION = "0.001";
$VERSION = eval $VERSION;

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
            Carp::croak "Clone::Choose version $param required. This is only version $VERSION" if $VERSION < $param;
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

1;

__END__

=head1 NAME

Clone::Choose - Choose appropriate clone utility

=head1 SYNOPSIS

  use Clone::Choose;

  my $data = {
      value => 42,
      href  => {
          set   => [ 'foo', 'bar' ],
          value => 'baz',
      },
  };

  my $cloned_data = clone $data;

  # it's also possible to use Clone::Choose and pass a clone preference
  use Clone::Choose qw(:Storable);

=head1 DESCRIPTION

C<Clone::Choose> checks several different moudules which provides a
C<clone()> function and selects an appropriate one.

=head1 EXPORTS

C<Clone::Choose> exports C<clone()> by default.

=head1 AUTHOR

  Jens Rehsack <rehsack at cpan dot org>
  Stefan Hermes <hermes at cpan dot org>

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
