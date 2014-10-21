package Pithub::GitData::Commits;
BEGIN {
  $Pithub::GitData::Commits::VERSION = '0.01000';
}

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::GitData::Commits

=head1 VERSION

version 0.01000

=head1 METHODS

=head2 create

=over

=item *

Create a Commit

    POST /repos/:user/:repo/git/commits

=back

Examples:

    $result = $p->git_data->commits->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            author => {
                date  => '2008-07-09T16:13:30+12:00',
                email => 'schacon@gmail.com',
                name  => 'Scott Chacon',
            },
            message => 'my commit message',
            parents => ['7d1b31e74ee336d15cbd21741bc88a537ed063a0'],
            tree    => '827efc6d56897b048c772eb4087f854f46256132',
        }
    );

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/git/commits', $args{user}, $args{repo} ), $args{data} );
}

=head2 get

=over

=item *

Get a Commit

    GET /repos/:user/:repo/git/commits/:sha

=back

Examples:

    $result = $p->git_data->commits->get(
        user => 'plu',
        repo => 'Pithub',
        sha  => 'df21b2660fb6',
    );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: sha' unless $args{sha};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/git/commits/%s', $args{user}, $args{repo}, $args{sha} ) );
}

__PACKAGE__->meta->make_immutable;

1;
