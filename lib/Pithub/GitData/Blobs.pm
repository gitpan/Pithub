package Pithub::GitData::Blobs;
BEGIN {
  $Pithub::GitData::Blobs::VERSION = '0.01001';
}

# ABSTRACT: Github v3 Git Data Blobs API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/git/blobs', $args{user}, $args{repo} ), $args{data} );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/git/blobs/%s', $args{user}, $args{repo}, $args{sha} ) );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::GitData::Blobs - Github v3 Git Data Blobs API

=head1 VERSION

version 0.01001

=head1 METHODS

=head2 create

=over

=item *

Create a Blob

    POST /repos/:user/:repo/git/blobs

=back

Examples:

    $result = $p->git_data->blobs->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            content  => 'Content of the blob',
            encoding => 'utf-8',
        }
    );

=head2 get

=over

=item *

Get a Blob

    GET /repos/:user/:repo/git/blobs/:sha

=back

Examples:

    $result = $p->git_data->blobs->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
    );

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

