package Pithub::PullRequests;
BEGIN {
  $Pithub::PullRequests::VERSION = '0.01001';
}

# ABSTRACT: Github v3 Pull Requests API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };
around qr{^merge_.*?_args$} => \&Pithub::Base::_merge_args;


sub commits {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls/%d/commits', $args{user}, $args{repo}, $args{pull_request_id} ) );
}


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/pulls', $args{user}, $args{repo} ), $args{data} );
}


sub files {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls/%d/files', $args{user}, $args{repo}, $args{pull_request_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls/%d', $args{user}, $args{repo}, $args{pull_request_id} ) );
}


sub is_merged {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls/%d/merge', $args{user}, $args{repo}, $args{pull_request_id} ) );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/pulls', $args{user}, $args{repo} ) );
}


sub merge {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( PUT => sprintf( '/repos/%s/%s/pulls/%d/merge', $args{user}, $args{repo}, $args{pull_request_id} ) );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: pull_request_id' unless $args{pull_request_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/pulls/%d', $args{user}, $args{repo}, $args{pull_request_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::PullRequests - Github v3 Pull Requests API

=head1 VERSION

version 0.01001

=head1 METHODS

=head2 commits

=over

=item *

List commits on a pull request

    GET /repos/:user/:repo/pulls/:id/commits

=back

Examples:

    $result = $p->pull_requests->commits(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1
    );

=head2 create

=over

=item *

Create a pull request

    POST /repos/:user/:repo/pulls

=back

Examples:

    $result = $p->pull_requests->create(
        user   => 'plu',
        repo => 'Pithub',
        data   => {
            base  => 'master',
            body  => 'Please pull this in!',
            head  => 'octocat:new-feature',
            title => 'Amazing new feature',
        }
    );

=head2 files

=over

=item *

List pull requests files

    GET /repos/:user/:repo/pulls/:id/files

=back

Examples:

    $result = $p->pull_requests->files(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1,
    );

=head2 get

=over

=item *

Get a single pull request

    GET /repos/:user/:repo/pulls/:id

=back

Examples:

    $result = $p->pull_requests->get(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1,
    );

=head2 is_merged

=over

=item *

Get if a pull request has been merged

    GET /repos/:user/:repo/pulls/:id/merge

=back

Examples:

    $result = $p->pull_requests->is_merged(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1,
    );

=head2 list

=over

=item *

List pull requests

    GET /repos/:user/:repo/pulls

=back

Examples:

    $result = $p->pull_requests->list(
        user => 'plu',
        repo => 'Pithub'
    );

=head2 merge

=over

=item *

Merge a pull request

    PUT /repos/:user/:repo/pulls/:id/merge

=back

Examples:

    $result = $p->pull_requests->merge(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1,
    );

=head2 update

=over

=item *

Update a pull request

    PATCH /repos/:user/:repo/pulls/:id

=back

Examples:

    $result = $p->pull_requests->update(
        user            => 'plu',
        repo            => 'Pithub',
        pull_request_id => 1,
        data            => {
            base  => 'master',
            body  => 'Please pull this in!',
            head  => 'octocat:new-feature',
            title => 'Amazing new feature',
        }
    );

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

