package Pithub::Issues::Labels;
BEGIN {
  $Pithub::Issues::Labels::VERSION = '0.01003';
}

# ABSTRACT: Github v3 Issue Labels API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub add {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/issues/%s/labels', $args{user}, $args{repo}, $args{issue_id} ), $args{data} );
}


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/labels', $args{user}, $args{repo} ), $args{data} );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label_id' unless $args{label_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/labels/%s', $args{user}, $args{repo}, $args{label_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label_id' unless $args{label_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/labels/%s', $args{user}, $args{repo}, $args{label_id} ) );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $milestone_id = $args{milestone_id} ) {
        return $self->request( GET => sprintf( '/repos/%s/%s/milestones/%s/labels', $args{user}, $args{repo}, $milestone_id ) );
    }
    elsif ( my $issue_id = $args{issue_id} ) {
        return $self->request( GET => sprintf( '/repos/%s/%s/issues/%s/labels', $args{user}, $args{repo}, $issue_id ) );
    }
    return $self->request( GET => sprintf( '/repos/%s/%s/labels', $args{user}, $args{repo} ) );
}


sub remove {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    if ( my $label_id = $args{label_id} ) {
        return $self->request( DELETE => sprintf( '/repos/%s/%s/issues/%s/labels/%s', $args{user}, $args{repo}, $args{issue_id}, $label_id ) );
    }
    return $self->request( DELETE => sprintf( '/repos/%s/%s/issues/%s/labels', $args{user}, $args{repo}, $args{issue_id} ) );
}


sub replace {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PUT => sprintf( '/repos/%s/%s/issues/%s/labels', $args{user}, $args{repo}, $args{issue_id} ), $args{data} );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label_id' unless $args{label_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/labels/%s', $args{user}, $args{repo}, $args{label_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Issues::Labels - Github v3 Issue Labels API

=head1 VERSION

version 0.01003

=head1 METHODS

=head2 add

=over

=item *

Add labels to an issue

    POST /repos/:user/:repo/issues/:id/labels

Examples:

    $result = $p->issues->labels->add(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        data     => ['Label1', 'Label2'],
    );

=back

=head2 create

=over

=item *

Create a label

    POST /repos/:user/:repo/labels

Examples:

    $result = $p->issues->labels->create(
        repo => 'Pithub',
        user => 'plu',
        data => {
            color => 'FFFFFF',
            name  => 'some label',
        }
    );

=back

=head2 delete

=over

=item *

Delete a label

    DELETE /repos/:user/:repo/labels/:id

Examples:

    $result = $p->issues->labels->delete(
        repo     => 'Pithub',
        user     => 'plu',
        label_id => 1,
    );

=back

=head2 get

=over

=item *

Get a single label

    GET /repos/:user/:repo/labels/:id

Examples:

    $result = $p->issues->labels->get(
        repo => 'Pithub',
        user => 'plu',
        label_id => 1,
    );

=back

=head2 list

=over

=item *

List all labels for this repository

    GET /repos/:user/:repo/labels

Examples:

    $result = $p->issues->labels->list(
        repo => 'Pithub',
        user => 'plu'
    );

=item *

List labels on an issue

    GET /repos/:user/:repo/issues/:id/labels

Examples:

    $result = $p->issues->labels->list(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=item *

Get labels for every issue in a milestone

    GET /repos/:user/:repo/milestones/:id/labels

Examples:

    $result = $p->issues->labels->get(
        repo         => 'Pithub',
        user         => 'plu',
        milestone_id => 1
    );

=back

=head2 remove

=over

=item *

Remove a label from an issue

    DELETE /repos/:user/:repo/issues/:id/labels/:id

Examples:

    $result = $p->issues->labels->delete(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        label_id => 1,
    );

=item *

Remove all labels from an issue

    DELETE /repos/:user/:repo/issues/:id/labels

Examples:

    $result = $p->issues->labels->delete(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=back

=head2 replace

=over

=item *

Replace all labels for an issue

    PUT /repos/:user/:repo/issues/:id/labels

Examples:

    $result = $p->issues->labels->replace(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        data     => [qw(label3 label4)],
    );

=back

=head2 update

=over

=item *

Update a label

    PATCH /repos/:user/:repo/labels/:id

Examples:

    $result = $p->issues->labels->update(
        repo     => 'Pithub',
        user     => 'plu',
        label_id => 1,
        data     => {
            color => 'FFFFFF',
            name  => 'API',
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

