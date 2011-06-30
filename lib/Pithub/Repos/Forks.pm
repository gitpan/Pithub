package Pithub::Repos::Forks;
BEGIN {
  $Pithub::Repos::Forks::VERSION = '0.01002';
}

# ABSTRACT: Github v3 Repo Forks API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $org = $args{org} ) {
        return $self->request( POST => sprintf( '/repos/%s/%s/forks', $args{user}, $args{repo} ), { org => $org } );
    }
    return $self->request( POST => sprintf( '/repos/%s/%s/forks', $args{user}, $args{repo} ) );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/forks', $args{user}, $args{repo} ) );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Repos::Forks - Github v3 Repo Forks API

=head1 VERSION

version 0.01002

=head1 METHODS

=head2 create

=over

=item *

Create a fork for the authenicated user.

    POST /repos/:user/:repo/forks

Examples:

    $result = $p->repos->forks->create(
        user => 'plu',
        repo => 'Pithub',
    );

    $result = $p->repos->forks->create(
        user => 'plu',
        repo => 'Pithub',
        org  => 'CPAN-API',
    );

=back

=head2 list

=over

=item *

List forks

    GET /repos/:user/:repo/forks

Examples:

    $result = $p->repos->forks->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

