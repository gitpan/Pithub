package Pithub::Repos::Keys;
BEGIN {
  $Pithub::Repos::Keys::VERSION = '0.01002';
}

# ABSTRACT: Github v3 Repo Keys API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/keys', $args{user}, $args{repo} ), $args{data} );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/keys/%s', $args{user}, $args{repo}, $args{key_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/keys/%s', $args{user}, $args{repo}, $args{key_id} ) );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/keys', $args{user}, $args{repo} ) );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/keys/%s', $args{user}, $args{repo}, $args{key_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Repos::Keys - Github v3 Repo Keys API

=head1 VERSION

version 0.01002

=head1 METHODS

=head2 create

=over

=item *

Create

    POST /repos/:user/:repo/keys

Examples:

    $result = $p->repos->keys->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            title => 'some key',
            key   => 'ssh-rsa AAA...',
        },
    );

=back

=head2 delete

=over

=item *

Delete

    DELETE /repos/:user/:repo/keys/:id

Examples:

    $result = $p->repos->keys->delete(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
    );

=back

=head2 get

=over

=item *

Get

    GET /repos/:user/:repo/keys/:id

Examples:

    $result = $p->repos->keys->get(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
    );

=back

=head2 list

=over

=item *

List

    GET /repos/:user/:repo/keys

Examples:

    $result = $p->repos->keys->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=head2 update

=over

=item *

Edit

    PATCH /repos/:user/:repo/keys/:id

Examples:

    $result = $p->repos->keys->update(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
        data   => { title => 'some new title' },
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

