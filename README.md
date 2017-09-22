# NAME

Clone::Choose - Choose appropriate clone utility

# SYNOPSIS

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

# DESCRIPTION

`Clone::Choose` checks several different moudules which provides a
`clone()` function and selects an appropriate one.

# EXPORTS

`Clone::Choose` exports `clone()` by default.

# AUTHOR

    Jens Rehsack <rehsack at cpan dot org>
    Stefan Hermes <hermes at cpan dot org>

# BUGS

Please report any bugs or feature requests to
`bug-Clone-Choose at rt.cpan.org`, or through the web interface at
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Clone-Choose](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Clone-Choose).
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Clone::Choose

You can also look for information at:

- RT: CPAN's request tracker

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=Clone-Choose](http://rt.cpan.org/NoAuth/Bugs.html?Dist=Clone-Choose)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/Clone-Choose](http://annocpan.org/dist/Clone-Choose)

- CPAN Ratings

    [http://cpanratings.perl.org/d/Clone-Choose](http://cpanratings.perl.org/d/Clone-Choose)

- Search CPAN

    [http://search.cpan.org/dist/Clone-Choose/](http://search.cpan.org/dist/Clone-Choose/)

# LICENSE AND COPYRIGHT

    Copyright 2017 Jens Rehsack
    Copyright 2017 Stefan Hermes

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

# SEE ALSO

[Clone](https://metacpan.org/pod/Clone), [Clone::PP](https://metacpan.org/pod/Clone::PP), [Storable](https://metacpan.org/pod/Storable)
