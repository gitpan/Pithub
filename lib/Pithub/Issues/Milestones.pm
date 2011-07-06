package Pithub::Issues::Milestones;
BEGIN {
  $Pithub::Issues::Milestones::VERSION = '0.01003';
}

# ABSTRACT: Github v3 Issue Milestones API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/milestones', $args{user}, $args{repo} ), $args{data} );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: milestone_id' unless $args{milestone_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/milestones/%s', $args{user}, $args{repo}, $args{milestone_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: milestone_id' unless $args{milestone_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/milestones/%s', $args{user}, $args{repo}, $args{milestone_id} ) );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/milestones', $args{user}, $args{repo} ) );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: milestone_id' unless $args{milestone_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/milestones/%s', $args{user}, $args{repo}, $args{milestone_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Issues::Milestones - Github v3 Issue Milestones API

=head1 VERSION

version 0.01003

=head1 METHODS

=head2 create

=over

=item *

Create a milestone

    POST /repos/:user/:repo/milestones

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

=back

=head2 delete

=over

=item *

Delete a milestone

    DELETE /repos/:user/:repo/milestones/:id

Examples:

    $result = $p->issues->milestones->delete(
        repo => 'Pithub',
        user => 'plu',
        milestone_id => 1,
    );

=back

=head2 get

=over

=item *

Get a single milestone

    GET /repos/:user/:repo/milestones/:id

Examples:

    $result = $p->issues->milestones->get(
        repo => 'Pithub',
        user => 'plu',
        milestone_id => 1,
    );

=back

=head2 list

=over

=item *

List milestones for an issue

    GET /repos/:user/:repo/milestones

Examples:

    $result = $p->issues->milestones->list(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=head2 update

=over

=item *

Update a milestone

    PATCH /repos/:user/:repo/milestones/:id

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

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

