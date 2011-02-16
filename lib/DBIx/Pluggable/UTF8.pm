use strict;
use warnings;
use utf8;
use Class::Method::Modifers;

package DBIx::Pluggable::UTF8;

sub init {
    my ($class, $pkg, $opts) = @_;

    Class::Method::Modifers->install_modifier(
        $pkg, 'around', 'connect', sub {
            my $next = shift;
            if ($_[1] =~ /^dbi:SQLite:/) {
                $_[4]->{sqlite_unicode} = 1;
            }
            $next->(@_);
        }
    );
}

1;

