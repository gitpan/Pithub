package Pithub::Repos::Collaborators;
BEGIN {
  $Pithub::Repos::Collaborators::VERSION = '0.01003';
}

# ABSTRACT: Github v3 Repo Collaborators API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub add {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: collaborator' unless $args{collaborator};
    $self->_validate_user_repo_args( \%args );
    return $self->request( PUT => sprintf( '/repos/%s/%s/collaborators/%s', $args{user}, $args{repo}, $args{collaborator} ) );
}


sub is_collaborator {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: collaborator' unless $args{collaborator};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/collaborators/%s', $args{user}, $args{repo}, $args{collaborator} ) );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/collaborators', $args{user}, $args{repo} ) );
}


sub remove {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: collaborator' unless $args{collaborator};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/collaborators/%s', $args{user}, $args{repo}, $args{collaborator} ) );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Repos::Collaborators - Github v3 Repo Collaborators API

=head1 VERSION

version 0.01003

=head1 METHODS

=head2 add

=over

=item *

Add collaborator

    PUT /repos/:user/:repo/collaborators/:user

Examples:

    $result = $p->repos->collaborators->add(
        user         => 'plu',
        repo         => 'Pithub',
        collaborator => 'rbo',
    );

=back

=head2 is_collaborator

=over

=item *

Get

    GET /repos/:user/:repo/collaborators/:user

Examples:

    $result = $p->repos->collaborators->is_collaborator(
        user         => 'plu',
        repo         => 'Pithub',
        collaborator => 'rbo',
    );

    if ( $result->is_success ) {
        print "rbo is added as collaborator to Pithub\n";
    }
    elsif ( $result->code == 404 ) {
        print "rbo is not added as collaborator to Pithub\n";
    }

=back

=head2 list

=over

=item *

List

    GET /repos/:user/:repo/collaborators

Examples:

    $result = $p->repos->collaborators->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=head2 remove

=over

=item *

Remove collaborator

    DELETE /repos/:user/:repo/collaborators/:user

Examples:

    $result = $p->repos->collaborators->remove(
        user         => 'plu',
        repo         => 'Pithub',
        collaborator => 'rbo',
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

