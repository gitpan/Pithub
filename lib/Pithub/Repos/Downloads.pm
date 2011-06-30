package Pithub::Repos::Downloads;
BEGIN {
  $Pithub::Repos::Downloads::VERSION = '0.01002';
}

# ABSTRACT: Github v3 Repo Downloads API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create {
    croak 'not supported';
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: download_id' unless $args{download_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/downloads/%s', $args{user}, $args{repo}, $args{download_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: download_id' unless $args{download_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/downloads/%s', $args{user}, $args{repo}, $args{download_id} ) );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/downloads', $args{user}, $args{repo} ) );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Repos::Downloads - Github v3 Repo Downloads API

=head1 VERSION

version 0.01002

=head1 METHODS

=head2 create

=over

=item *

Create a new download

    POST /repos/:user/:repo/downloads

Examples:

    $result = $p->repos->downloads->create(
        user => 'plu',
        repo => 'Pithub',
        data => { name => 'some download' },
    );

=back

TODO: Creating downloads is currently not supported!

=head2 delete

=over

=item *

Delete a download

    DELETE /repos/:user/:repo/downloads/:id

Examples:

    $result = $p->repos->downloads->delete(
        user        => 'plu',
        repo        => 'Pithub',
        download_id => 1,
    );

=back

=head2 get

=over

=item *

Get a single download

    GET /repos/:user/:repo/downloads/:id

Examples:

    $result = $p->repos->downloads->get(
        user        => 'plu',
        repo        => 'Pithub',
        download_id => 1,
    );

=back

=head2 list

=over

=item *

List downloads for a repository

    GET /repos/:user/:repo/downloads

Examples:

    $result = $p->repos->downloads->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

