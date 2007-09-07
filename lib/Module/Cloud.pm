package Module::Cloud;

use warnings;
use strict;
use Class::MethodMaker;
use HTML::TagCloud;
use File::Find::Rule::MMagic;
use Module::ExtractUse;

our $VERSION = '0.04';


use Class::MethodMaker
    [ new   => [ qw/-hash new/ ],
      array => 'dir',
    ];


sub get_cloud {
    my $self = shift;

    my @text_files;

    for my $dir ($self->dir) {
      push @text_files,
           grep { !/\/Makefile.PL$/ }
           grep { !/\.t$/ } 
           grep { !/\/\.svn\// } 
           find (file => magic => [ qw(text/* x-system/*) ], in => $dir);
    }

    my $extractor = Module::ExtractUse->new;
    my %modules;
    for my $textfile (@text_files) {
        my $used = $extractor->extract_use($textfile);
        $modules{$_}++ for keys %{ $used->{found} };
    }

    my $cloud = HTML::TagCloud->new;
    while (my ($module, $count) = each %modules) {
        $cloud->add(
            $module,
            "http://search.cpan.org/search?query=$module",
            $count
        );
    }
    $cloud;
}

1;

__END__

=head1 NAME

Module::Cloud - Generates a tag cloud for modules used in given code

=head1 VERSION

This document describes version 0.01 of C<Module::Cloud>.

=head1 SYNOPSIS

  use Module::Cloud;
  my $clouder = Module::Cloud->new(dir => \@dirs);
  my $cloud = $clouder->get_cloud;  # returns an HTML::TagCloud object
  print $cloud->html_and_css;

=head1 DESCRIPTION

This class traverses the given directories, searches for perl code, extracts
the modules used by this code and generates a L<HTML::TagCloud> object that
gives an impression of how often each module is used.

=head1 METHODS

=over 4

=item new()

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. 

=item dir()

An array accessor. See L<Class::Method::array> for details on related methods
provided.

=item get_cloud()

Traverses the directories set on the C<dir> accessor and searches for files
containing perl code. For each such file, the modules it uses are extracted.
From this data a L<HTML::TagCloud> object is created and returned. The more
often a module is used the bigger it will appear in the tag cloud.

=back

=head1 DIAGNOSTICS

There are no diagnostics for this module.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-module-cloud@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

Original idea and code by Greg McCarroll (CPAN ID: GMCCAR).

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut

