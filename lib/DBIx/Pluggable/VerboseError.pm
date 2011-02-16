use strict;
use warnings;
use utf8;

package DBIx::Pluggable::VerboseError;
use Carp::Clan qw{^(DBIx?::|DBD::)};
use Data::Dumper ();

sub init {
    my ( $class, $pkg, $opts ) = @_;

    Class::Method::Modifers->install_modifier(
        $pkg, 'around', 'connect', sub {
            my $next = shift;
            if ($_[4]->{RaiseError}) {
                Carp::croak("Do not set RaiseError when using $class plugin");
            }
            $next->(@_);
        }
    );
    Class::Method::Modifers->install_modifier(
        "$pkg\::db", 'around', 'prepare', sub {
            my $next = shift;
            my $sth = $next->(@_) or do {
                handle_error($_[1], undef, $_[0]->errstr);
            };
            $sth->{private_sql} = $_[1];
            return $sth;
        }
    );
    Class::Method::Modifers->install_modifier(
        "$pkg\::st", 'around', 'execute', sub {
            my $next = shift;
            $next->(@_) or do {
                handle_error($_[0]->{private_sql}, \@args, $_[0]->errstr);
            };
        }
    );
}

sub handle_error {
    my ( $stmt, $bind, $reason ) = @_;

    $stmt =~ s/\n/\n          /gm;
    my $err = sprintf <<"TRACE", $reason, $stmt, defined($bind) ? Data::Dumper::Dumper($bind) : q{'none'};
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@ DBI 's Exception         @@@@@
Reason  : %s
SQL     : %s
BIND    : %s
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
TRACE
    $err =~ s/\n\Z//;
    croak $err;
}

1;

