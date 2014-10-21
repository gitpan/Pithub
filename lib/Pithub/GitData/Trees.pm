package Pithub::GitData::Trees;
BEGIN {
  $Pithub::GitData::Trees::VERSION = '0.01001';
}

# ABSTRACT: Github v3 Git Data Trees API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/git/trees', $args{user}, $args{repo} ), $args{data} );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    my $path = sprintf( '/repos/%s/%s/git/trees/%s', $args{user}, $args{repo}, $args{sha} );
    my $options = {};
    if ( $args{recursive} ) {
        $options->{prepare_uri} = sub {
            my ($uri) = @_;
            $uri->query_form( recursive => 1 );
        };
    }
    return $self->request( GET => $path, undef, $options );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::GitData::Trees - Github v3 Git Data Trees API

=head1 VERSION

version 0.01001

=head1 METHODS

=head2 create

=over

=item *

Create a Tree

    POST /repos/:user/:repo/git/trees

=back

Examples:

    $result = $p->git_data->trees->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            tree => [
                {
                    path => 'file.pl',
                    mode => '100644',
                    type => 'blob',
                    sha  => '44b4fc6d56897b048c772eb4087f854f46256132',
                }
            ]
        }
    );

Parameters in C<< data >> hashref:

=over

=item *

B<base_tree>: optional String of the SHA1 of the tree you want to
update with new data

=item *

B<tree>: Array of Hash objects (of path, mode, type and sha)
specifying a tree structure

=item *

B<tree.path>: String of the file referenced in the tree

=item *

B<tree.mode>: String of the file mode - one of 100644 for file
(blob), 100755 for executable (blob), 040000 for subdirectory
(tree), 160000 for submodule (commit) or 120000 for a blob that
specifies the path of a symlink

=item *

B<tree.type>: String of blob, tree, commit

=item *

B<tree.sha>: String of SHA1 checksum ID of the object in the tree

=item *

B<tree.content>: String of content you want this file to have -
GitHub will write this blob out and use that SHA for this entry.
Use either this or tree.sha

=back

=head2 get

=over

=item *

Get a Tree

    GET /repos/:user/:repo/git/trees/:sha

Examples:

    $result = $p->git_data->trees->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6'
    );

=item *

Get a Tree Recursively

    GET /repos/:user/:repo/git/trees/:sha?recursive=1

=back

    $result = $p->git_data->trees->get(
        user      => 'plu',
        repo      => 'Pithub',
        sha       => 'df21b2660fb6',
        recursive => 1,
    );

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

