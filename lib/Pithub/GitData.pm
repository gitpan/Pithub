package Pithub::GitData;
{
  $Pithub::GitData::VERSION = '0.01016';
}

# ABSTRACT: Github v3 Git Data API

use Moo;
use Carp qw(croak);
use Pithub::GitData::Blobs;
use Pithub::GitData::Commits;
use Pithub::GitData::References;
use Pithub::GitData::Tags;
use Pithub::GitData::Trees;
extends 'Pithub::Base';


sub blobs {
    return shift->_create_instance('Pithub::GitData::Blobs');
}


sub commits {
    return shift->_create_instance('Pithub::GitData::Commits');
}


sub references {
    return shift->_create_instance('Pithub::GitData::References');
}


sub tags {
    return shift->_create_instance('Pithub::GitData::Tags');
}


sub trees {
    return shift->_create_instance('Pithub::GitData::Trees');
}

1;

__END__
=pod

=head1 NAME

Pithub::GitData - Github v3 Git Data API

=head1 VERSION

version 0.01016

=head1 METHODS

=head2 blobs

Provides access to L<Pithub::GitData::Blobs>.

=head2 commits

Provides access to L<Pithub::GitData::Commits>.

=head2 references

Provides access to L<Pithub::GitData::References>.

=head2 tags

Provides access to L<Pithub::GitData::Tags>.

=head2 trees

Provides access to L<Pithub::GitData::Trees>.

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

