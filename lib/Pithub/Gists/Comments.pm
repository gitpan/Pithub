package Pithub::Gists::Comments;
BEGIN {
  $Pithub::Gists::Comments::VERSION = '0.01002';
}

# ABSTRACT: Github v3 Gist Comments API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( POST => sprintf( '/gists/%s/comments', $args{gist_id} ), $args{data} );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    return $self->request( DELETE => sprintf( '/gists/comments/%s', $args{comment_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    return $self->request( GET => sprintf( '/gists/comments/%s', $args{comment_id} ) );
}


sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( GET => sprintf( '/gists/%s/comments', $args{gist_id} ) );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( PATCH => sprintf( '/gists/comments/%s', $args{comment_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Gists::Comments - Github v3 Gist Comments API

=head1 VERSION

version 0.01002

=head1 METHODS

=head2 create

=over

=item *

Create a comment

    POST /gists/:gist_id/comments

Examples:

    $result = $p->gists->comments->create(
        gist_id => 1,
        data    => { body => 'some comment' },
    );

=back

=head2 delete

=over

=item *

Delete a comment

    DELETE /gists/comments/:id

Examples:

    $result = $p->gists->comments->delete( comment_id => 1 );

=back

=head2 get

=over

=item *

Get a single comment

    GET /gists/comments/:id

Examples:

    $result = $p->gists->comments->get( comment_id => 1 );

=back

=head2 list

=over

=item *

List comments on a gist

    GET /gists/:gist_id/comments

Examples:

    $result = $p->gists->comments->list( gist_id => 1 );

=back

=head2 update

=over

=item *

Edit a comment

    PATCH /gists/comments/:id

Examples:

    $result = $p->gists->comments->update(
        comment_id => 1,
        data       => { body => 'some comment' }
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

