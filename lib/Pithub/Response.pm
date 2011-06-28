package Pithub::Response;
BEGIN {
  $Pithub::Response::VERSION = '0.01001';
}

# ABSTRACT: Github v3 response object

use Moose;
use HTTP::Response;
use namespace::autoclean;


has 'request' => (
    is       => 'ro',
    isa      => 'Pithub::Request',
    required => 1,
);


has 'http_response' => (
    handles => {
        code    => 'code',
        content => 'content',
        success => 'is_success',
    },
    is       => 'rw',
    isa      => 'HTTP::Response',
    required => 0,
);


sub parse_response {
    my ( $self, $str ) = @_;
    my $res = HTTP::Response->parse($str);
    $self->http_response($res);
    return $res;
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Response - Github v3 response object

=head1 VERSION

version 0.01001

=head1 ATTRIBUTES

=head2 request

The L<Pithub::Request> object.

=head2 http_response

The L<HTTP::Response> object. There are following delegate methods
installed for convenience:

=over

=item *

B<code>: http_response->code

=item *

B<content>: http_response->content

=item *

B<success>: http_response->is_cuess

=back

=head1 METHODS

=head2 parse_response

Utility method.

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

