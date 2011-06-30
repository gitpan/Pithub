package Pithub::PullRequests::Comments;
BEGIN {
  $Pithub::PullRequests::Comments::VERSION = '0.01002';
}

# ABSTRACT: Github v3 Pull Request Comments API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/pulls/%s/comments', $args{user}, $args{repo}, $args{pull_request_id} ), $args{data} );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/pulls/comments/%s', $args{user}, $args{repo}, $args{comment_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls/comments/%s', $args{user}, $args{repo}, $args{comment_id} ) );
}


sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls/%s/comments', $args{user}, $args{repo}, $args{pull_request_id} ) );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/pulls/comments/%s', $args{user}, $args{repo}, $args{comment_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::PullRequests::Comments - Github v3 Pull Request Comments API

=head1 VERSION

version 0.01002

=head1 METHODS

=head2 create

=over

=item *

Create a comment

    POST /repos/:user/:repo/pulls/:id/comments

Examples:

    $result = $p->pull_requests->comments->create(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
        data            => {
            body      => 'Nice change',
            commit_id => '6dcb09b5b57875f334f61aebed695e2e4193db5e',
            path      => 'file1.txt',
            position  => 4,
        }
    );

=back

=head2 delete

=over

=item *

Delete a comment

    DELETE /repos/:user/:repo/pulls/comments/:id

Examples:

    $result = $p->pull_requests->comments->delete(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
    );

=back

=head2 get

=over

=item *

Get a single comment

    GET /repos/:user/:repo/pulls/comments/:id

Examples:

    $result = $p->pull_requests->comments->get(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
    );

=back

=head2 list

=over

=item *

List comments on a pull request

    GET /repos/:user/:repo/pulls/:id/comments

Examples:

    $result = $p->pull_requests->comments->list(
        repo            => 'Pithub',
        user            => 'plu',
        pull_request_id => 1,
    );

=back

=head2 update

=over

=item *

Edit a comment

    PATCH /repos/:user/:repo/pulls/comments/:id

Examples:

    $result = $p->pull_requests->comments->update(
        repo       => 'Pithub',
        user       => 'plu',
        comment_id => 1,
        data       => { body => 'some updated comment' },
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

