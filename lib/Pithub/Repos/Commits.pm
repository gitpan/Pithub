package Pithub::Repos::Commits;
BEGIN {
  $Pithub::Repos::Commits::VERSION = '0.01002';
}

# ABSTRACT: Github v3 Repo Commits API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create_comment {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/commits/%s/comments', $args{user}, $args{repo}, $args{sha} ), $args{data} );
}


sub delete_comment {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/comments/%s', $args{user}, $args{repo}, $args{comment_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/commits/%s', $args{user}, $args{repo}, $args{sha} ) );
}


sub get_comment {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/comments/%s', $args{user}, $args{repo}, $args{comment_id} ) );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/commits', $args{user}, $args{repo} ) );
}


sub list_comments {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $sha = $args{sha} ) {
        return $self->request( GET => sprintf( '/repos/%s/%s/commits/%s/comments', $args{user}, $args{repo}, $sha ) );
    }
    return $self->request( GET => sprintf( '/repos/%s/%s/comments', $args{user}, $args{repo} ) );
}


sub update_comment {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/comments/%s', $args{user}, $args{repo}, $args{comment_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Repos::Commits - Github v3 Repo Commits API

=head1 VERSION

version 0.01002

=head1 METHODS

=head2 create_comment

=over

=item *

Create a commit comment

    POST /repos/:user/:repo/commits/:sha/comments

Examples:

    $result = $p->repos->commits->create_comment(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
        data => { body => 'some comment' },
    );

=back

=head2 delete_comment

=over

=item *

Delete a commit comment

    DELETE /repos/:user/:repo/comments/:id

Examples:

    $result = $p->repos->commits->delete_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
    );

=back

=head2 get

=over

=item *

Get a single commit

    GET /repos/:user/:repo/commits/:sha

Examples:

    $result = $p->repos->commits->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
    );

=back

=head2 get_comment

=over

=item *

Get a single commit comment

    GET /repos/:user/:repo/comments/:id

Examples:

    $result = $p->repos->commits->get_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
    );

=back

=head2 list

=over

=item *

List commits on a repository

    GET /repos/:user/:repo/commits

Examples:

    $result = $p->repos->commits->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=head2 list_comments

=over

=item *

List commit comments for a repository

Commit Comments leverage these custom mime types. You can read more
about the use of mimes types in the API here. TODO: Link github API

    GET /repos/:user/:repo/comments

Examples:

    $result = $p->repos->commits->list_comments(
        user => 'plu',
        repo => 'Pithub',
    );

=item *

List comments for a single commit

    GET /repos/:user/:repo/commits/:sha/comments

Examples:

    $result = $p->repos->commits->list_comments(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
    );

=back

=head2 update_comment

=over

=item *

Update a commit comment

    PATCH /repos/:user/:repo/comments/:id

Examples:

    $result = $p->repos->commits->update_comment(
        user       => 'plu',
        repo       => 'Pithub',
        comment_id => 1,
        data       => { body => 'updated comment' },
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

