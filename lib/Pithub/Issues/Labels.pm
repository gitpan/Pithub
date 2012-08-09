package Pithub::Issues::Labels;
{
  $Pithub::Issues::Labels::VERSION = '0.01014';
}

# ABSTRACT: Github v3 Issue Labels API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';


sub add {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/issues/%s/labels', delete $args{user}, delete $args{repo}, delete $args{issue_id} ),
        %args,
    );
}


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/labels', delete $args{user}, delete $args{repo} ),
        %args,
    );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label' unless $args{label};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/repos/%s/%s/labels/%s', delete $args{user}, delete $args{repo}, delete $args{label} ),
        %args,
    );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label' unless $args{label};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/labels/%s', delete $args{user}, delete $args{repo}, delete $args{label} ),
        %args,
    );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $milestone_id = delete $args{milestone_id} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/repos/%s/%s/milestones/%s/labels', delete $args{user}, delete $args{repo}, $milestone_id ),
            %args,
        );
    }
    elsif ( my $issue_id = delete $args{issue_id} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/repos/%s/%s/issues/%s/labels', delete $args{user}, delete $args{repo}, $issue_id ),
            %args
        );
    }
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/labels', delete $args{user}, delete $args{repo} ),
        %args,
    );
}


sub remove {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    if ( my $label = delete $args{label} ) {
        return $self->request(
            method => 'DELETE',
            path   => sprintf( '/repos/%s/%s/issues/%s/labels/%s', delete $args{user}, delete $args{repo}, delete $args{issue_id}, $label ),
            %args,
        );
    }
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/repos/%s/%s/issues/%s/labels', delete $args{user}, delete $args{repo}, delete $args{issue_id} ),
        %args,
    );
}


sub replace {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PUT',
        path   => sprintf( '/repos/%s/%s/issues/%s/labels', delete $args{user}, delete $args{repo}, delete $args{issue_id} ),
        %args,
    );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label' unless $args{label};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/repos/%s/%s/labels/%s', delete $args{user}, delete $args{repo}, delete $args{label} ),
        %args,
    );
}

1;

__END__
=pod

=head1 NAME

Pithub::Issues::Labels - Github v3 Issue Labels API

=head1 VERSION

version 0.01014

=head1 METHODS

=head2 add

=over

=item *

Add labels to an issue

    POST /repos/:user/:repo/issues/:id/labels

Examples:

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->add(
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

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->create(
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

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->delete(
        repo     => 'Pithub',
        user     => 'plu',
        label => 1,
    );

=back

=head2 get

=over

=item *

Get a single label

    GET /repos/:user/:repo/labels/:id

Examples:

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->get(
        repo => 'Pithub',
        user => 'plu',
        label => 1,
    );

=back

=head2 list

=over

=item *

List all labels for this repository

    GET /repos/:user/:repo/labels

Examples:

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->list(
        repo => 'Pithub',
        user => 'plu'
    );

=item *

List labels on an issue

    GET /repos/:user/:repo/issues/:id/labels

Examples:

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->list(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=item *

Get labels for every issue in a milestone

    GET /repos/:user/:repo/milestones/:id/labels

Examples:

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->get(
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

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->delete(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        label => 1,
    );

=item *

Remove all labels from an issue

    DELETE /repos/:user/:repo/issues/:id/labels

Examples:

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->delete(
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

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->replace(
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

    my $l = Pithub::Issues::Labels->new;
    my $result = $l->update(
        repo     => 'Pithub',
        user     => 'plu',
        label => 1,
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

