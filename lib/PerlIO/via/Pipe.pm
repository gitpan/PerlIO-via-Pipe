package PerlIO::via::Pipe;

use strict;
use warnings;
require 5.008;


our $VERSION = '0.01';


use base 'Exporter';


our %EXPORT_TAGS = (
    util  => [ qw(set_io_pipe) ],
);


our @EXPORT_OK = @{ $EXPORT_TAGS{all} = [ map { @$_ } values %EXPORT_TAGS ] };


sub set_io_pipe ($) {
    our $pipe = shift;
}


sub PUSHED {
    my ($class, $mode) = @_;
    return -1 if $mode ne 'r';
    my $buf = '';
    bless \$buf, $class;
}


sub FILL {
    my ($self, $fh) = @_;
    my $line = <$fh>;
    return unless defined $line;
    our $pipe;
    $pipe->filter($line);
}


1;


__END__



=head1 NAME

PerlIO::via::Pipe - PerlIO layer to filter input through a Text::Pipe

=head1 SYNOPSIS

    use PerlIO::via::Pipe 'set_io_pioe';
    use Text::Pipe 'pipe';

    my $pipe = pipe(...) | pipe(...);

    open my $file, '<:via(Pipe)', 'foo.txt'
        or die "can't open foo.txt $!\n";


=head1 DESCRIPTION

This package implements a PerlIO layer for reading files only. It exports, on
request, a function C<set_io_pipe> that you can use to set a L<Text::Pipe>
pipe. If you then use the C<Pipe> layer as shown in the synopsis, the input
gets filtered through the pipe.

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<perlioviapipe> tag.

=head1 VERSION 
                   
This document describes version 0.01 of L<PerlIO::via::Pipe>.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<<bug-perlio-via-pipe@rt.cpan.org>>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

