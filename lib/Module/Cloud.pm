package Module::Cloud;

use warnings;
use strict;
use HTML::TagCloud;
use File::Find::Rule::MMagic;
use Module::ExtractUse;


our $VERSION = '0.08';


use base 'Class::Accessor::Complex';


__PACKAGE__
    ->mk_new
    ->mk_array_accessors('dir');


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

=item new

  my $clouder = Module::Cloud->new(dir => \@dirs);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. 

=item dir
=item dir_clear
=item dir_count
=item dir_index
=item dir_isset
=item dir_pop
=item dir_push
=item dir_reset
=item dir_set
=item dir_shift
=item dir_splice
=item dir_unshift

An array accessor. See L<Class::Method::array> for details on related methods
provided.

=item get_cloud

  my $cloud = $clouder->get_cloud;

Traverses the directories set on the C<dir> accessor and searches for files
containing perl code. For each such file, the modules it uses are extracted.
From this data a L<HTML::TagCloud> object is created and returned. The more
often a module is used the bigger it will appear in the tag cloud.

=back

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<modulecloud> tag.

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

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
