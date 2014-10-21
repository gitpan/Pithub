package Pithub::Issues::Milestones;
BEGIN {
  $Pithub::Issues::Milestones::VERSION = '0.01000';
}

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Issues::Milestones

=head1 VERSION

version 0.01000

=head1 METHODS

=head2 create

=over

=item *

Create a milestone

    POST /repos/:user/:repo/milestones

=back

Examples:

    $result = $p->issues->milestones->create(
        repo => 'Pithub',
        user => 'plu',
        data => {
            description => 'String',
            due_on      => 'Time',
            state       => 'open or closed',
            title       => 'String'
        }
    );

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/milestones', $args{user}, $args{repo} ), $args{data} );
}

=head2 delete

=over

=item *

Delete a milestone

    DELETE /repos/:user/:repo/milestones/:id

=back

Examples:

    $result = $p->issues->milestones->delete(
        repo => 'Pithub',
        user => 'plu',
        milestone_id => 1,
    );

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: milestone_id' unless $args{milestone_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/milestones/%d', $args{user}, $args{repo}, $args{milestone_id} ) );
}

=head2 get

=over

=item *

Get a single milestone

    GET /repos/:user/:repo/milestones/:id

=back

Examples:

    $result = $p->issues->milestones->get(
        repo => 'Pithub',
        user => 'plu',
        milestone_id => 1,
    );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: milestone_id' unless $args{milestone_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/milestones/%d', $args{user}, $args{repo}, $args{milestone_id} ) );
}

=head2 list

=over

=item *

List milestones for an issue

    GET /repos/:user/:repo/milestones

=back

Examples:

    $result = $p->issues->milestones->list(
        repo => 'Pithub',
        user => 'plu',
    );

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/milestones', $args{user}, $args{repo} ) );
}

=head2 update

=over

=item *

Update a milestone

    PATCH /repos/:user/:repo/milestones/:id

=back

Examples:

    $result = $p->issues->milestones->update(
        repo => 'Pithub',
        user => 'plu',
        data => {
            description => 'String',
            due_on      => 'Time',
            state       => 'open or closed',
            title       => 'String'
        }
    );

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: milestone_id' unless $args{milestone_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/milestones/%d', $args{user}, $args{repo}, $args{milestone_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
