package Pithub::Issues::Comments;
BEGIN {
  $Pithub::Issues::Comments::VERSION = '0.01002';
}

# ABSTRACT: Github v3 Issue Comments API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/issues/%s/comments', $args{user}, $args{repo}, $args{issue_id} ), $args{data} );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/issues/comments/%s', $args{user}, $args{repo}, $args{comment_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/issues/comments/%s', $args{user}, $args{repo}, $args{comment_id} ) );
}


sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/issues/%s/comments', $args{user}, $args{repo}, $args{issue_id} ) );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/issues/comments/%s', $args{user}, $args{repo}, $args{comment_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Issues::Comments - Github v3 Issue Comments API

=head1 VERSION

version 0.01002

=head1 METHODS

=head2 create

=over

=item *

Create a comment

    POST /repos/:user/:repo/issues/:id/comments

Examples:

    $result = $p->issues->comments->create(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        data     => { body => 'some comment' }
    );

=back

=head2 delete

=over

=item *

Delete a comment

    DELETE /repos/:user/:repo/issues/comments/:id

Examples:

    $result = $p->issues->comments->delete(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
    );

=back

=head2 get

=over

=item *

Get a single comment

    GET /repos/:user/:repo/issues/comments/:id

Examples:

    $result = $p->issues->comments->get(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
    );

=back

=head2 list

=over

=item *

List comments on an issue

    GET /repos/:user/:repo/issues/:id/comments

Examples:

    $result = $p->issues->comments->list(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=back

=head2 update

=over

=item *

Edit a comment

    PATCH /repos/:user/:repo/issues/comments/:id

Examples:

    $result = $p->issues->comments->update(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
        data       => { body => 'some comment' },
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

