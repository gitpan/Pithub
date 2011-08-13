package Pithub::Gists::Comments;
BEGIN {
  $Pithub::Gists::Comments::VERSION = '0.01006';
}

# ABSTRACT: Github v3 Gist Comments API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request(
        method => 'POST',
        path   => sprintf( '/gists/%s/comments', delete $args{gist_id} ),
        %args,
    );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/gists/comments/%s', delete $args{comment_id} ),
        %args,
    );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/gists/comments/%s', delete $args{comment_id} ),
        %args,
    );
}


sub list {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request(
        method => 'GET',
        path   => sprintf( '/gists/%s/comments', delete $args{gist_id} ),
        %args,
    );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: comment_id' unless $args{comment_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/gists/comments/%s', delete $args{comment_id} ),
        %args,
    );
}

1;

__END__
=pod

=head1 NAME

Pithub::Gists::Comments - Github v3 Gist Comments API

=head1 VERSION

version 0.01006

=head1 METHODS

=head2 create

=over

=item *

Create a comment

    POST /gists/:gist_id/comments

Parameters:

=over

=item *

B<gist_id>: mandatory integer

=item *

B<data>: mandatory hashref, having following keys:

=over

=item *

B<body>: mandatory string

=back

=back

Examples:

    my $c = Pithub::Gists::Comments->new;
    my $result = $c->create(
        gist_id => 1,
        data    => { body => 'Just commenting for the sake of commenting' },
    );

Response: C<< Status: 201 Created >>

    {
        "id": 1,
        "url": "https://api.github.com/gists/comments/1",
        "body": "Just commenting for the sake of commenting",
        "user": {
            "login": "octocat",
            "id": 1,
            "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
            "url": "https://api.github.com/users/octocat"
        },
        "created_at": "2011-04-18T23:23:56Z"
    }

=back

=head2 delete

=over

=item *

Delete a comment

    DELETE /gists/comments/:id

Parameters:

=over

=item *

B<comment_id>: mandatory integer

=back

Examples:

    my $c = Pithub::Gists::Comments->new;
    my $result = $c->delete( comment_id => 1 );

Response: C<< Status: 204 No Content >>

=back

=head2 get

=over

=item *

Get a single comment

    GET /gists/comments/:id

Parameters:

=over

=item *

B<comment_id>: mandatory integer

=back

Examples:

    my $c = Pithub::Gists::Comments->new;
    my $result = $c->get( comment_id => 1 );

Response: C<< Status: 200 OK >>

    {
        "id": 1,
        "url": "https://api.github.com/gists/comments/1",
        "body": "Just commenting for the sake of commenting",
        "user": {
            "login": "octocat",
            "id": 1,
            "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
            "url": "https://api.github.com/users/octocat"
        },
        "created_at": "2011-04-18T23:23:56Z"
    }

=back

=head2 list

=over

=item *

List comments on a gist

    GET /gists/:gist_id/comments

Parameters:

=over

=item *

B<gist_id>: mandatory integer

=back

Examples:

    my $c = Pithub::Gists::Comments->new;
    my $result = $c->list( gist_id => 1 );

Response: C<< Status: 200 OK >>

    [
        {
            "id": 1,
            "url": "https://api.github.com/gists/comments/1",
            "body": "Just commenting for the sake of commenting",
            "user": {
                "login": "octocat",
                "id": 1,
                "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
                "url": "https://api.github.com/users/octocat"
            },
            "created_at": "2011-04-18T23:23:56Z"
        }
    ]

=back

=head2 update

=over

=item *

Edit a comment

    PATCH /gists/comments/:id

Parameters:

=over

=item *

B<comment_id>: mandatory integer

=item *

B<data>: mandatory hashref, having following keys:

=over

=item *

B<body>: mandatory string

=back

=back

Examples:

    my $c = Pithub::Gists::Comments->new;
    my $result = $c->update(
        comment_id => 1,
        data       => { body => 'some comment' }
    );

Response: C<< Status: 200 OK >>

    {
        "id": 1,
        "url": "https://api.github.com/gists/comments/1",
        "body": "Just commenting for the sake of commenting",
        "user": {
            "login": "octocat",
            "id": 1,
            "gravatar_url": "https://github.com/images/error/octocat_happy.gif",
            "url": "https://api.github.com/users/octocat"
        },
        "created_at": "2011-04-18T23:23:56Z"
    }

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

