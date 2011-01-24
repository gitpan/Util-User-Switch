=head1 NAME

Util::User::Switch - Become a user by Setting uid/gid or invoking sudo

=cut
package Util::User::Switch;

=head1 VERSION

This documentation describes version 0.01

=cut
use version;      our $VERSION = qv( 0.01 );

use warnings;
use strict;
use Carp;

=head1 SYNOPSIS

 use Util::User::Switch;

 my ( $uid, $gid ) = Util::User::Switch->setuidgid( 'joe' );

 Util::User::Switch->sudo( 'root' );

=head1 DESCRIPTION

=head2 setuidgid( user )

(As superuser) sets uid, gid, effective uid, and effective gid as those
of 'user'. Returns an the uid and gid of the target user in list context,
or an ARRAY reference in scalar context.

=cut
sub setuidgid
{
    my ( $class, $user ) = @_;

    return undef unless my @pw = getpwnam( $user ||= 'root' );

    my @id = map { sprintf '%d', $_ } @pw[2,3];
    my $self = ( getpwuid $< )[0];

    if ( $user ne $self )
    {
        ( $<, $>, $(, $) ) = ( $id[0], @id, join ' ', $id[1], $id[1] );
        return undef if $> != $id[0];
    }

    return wantarray ? @id : \@id;
}

=head2 sudo( user )

Invokes system sudo. Becomes 'root' if user is not specified.

=cut
sub sudo
{
    my ( $class, $user ) = @_;
    my $self = ( getpwuid $< )[0];
 
    return $self if $self eq ( $user ||= 'root' );

    warn "$self: need '$user' priviledge, invoking sudo.\n";
    croak "exec $0: $!" unless exec 'sudo', '-u', $user, $0, @ARGV;
}

=head1 AUTHOR

Kan Liu

=head1 COPYRIGHT and LICENSE

Copyright (c) 2010. Kan Liu

This program is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

__END__
