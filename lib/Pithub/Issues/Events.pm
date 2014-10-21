package Pithub::Issues::Events;
BEGIN {
  $Pithub::Issues::Events::VERSION = '0.01000';
}

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Issues::Events

=head1 VERSION

version 0.01000

=head1 METHODS

=head2 get

=over

=item *

Get a single event

    GET /repos/:user/:repo/issues/events/:id

=back

Examples:

    $result = $p->issues->events->get(
        repo     => 'Pithub',
        user     => 'plu',
        event_id => 1,
    );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: event_id' unless $args{event_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/issues/events/%d', $args{user}, $args{repo}, $args{event_id} ) );
}

=head2 list

=over

=item *

List events for an issue

    GET /repos/:user/:repo/issues/:issue_id/events

Examples:

    $result = $p->issues->events->list(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=item *

List events for a repository

    GET /repos/:user/:repo/issues/events

=back

    $result = $p->issues->events->list(
        repo => 'Pithub',
        user => 'plu',
    );

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $issue_id = $args{issue_id} ) {
        return $self->request( GET => sprintf( '/repos/%s/%s/issues/%d/events', $args{user}, $args{repo}, $issue_id ) );
    }
    return $self->request( GET => sprintf( '/repos/%s/%s/issues/events', $args{user}, $args{repo} ) );
}

__PACKAGE__->meta->make_immutable;

1;
