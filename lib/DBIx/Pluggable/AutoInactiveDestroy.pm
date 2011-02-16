use strict;
use warnings;
use utf8;
use Class::Method::Modifers;

package DBIx::Pluggable::AutoInactiveDestroy;

sub init {
    my ($class, $pkg, $opts) = @_;

    Class::Method::Modifers->install_modifier(
        $pkg, 'around', 'connect', sub {
            my $next = shift;
            $_[4]->{AutoInactiveDestroy} = 1;
            $next->(@_);
        }
    );
}

1;

