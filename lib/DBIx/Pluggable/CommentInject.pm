use strict;
use warnings;
use utf8;

package DBIx::Pluggable::CommentInject;


sub init {
    my ( $class, $pkg, $opts ) = @_;

    Class::Method::Modifers->install_modifier(
        "$pkg\::st", 'around', 'prepare', sub {
            my $next = shift;

            # inject file/line to help tuning
            my ( $package, $file, $line );
            my $i = 0;
            while ( ( $package, $file, $line ) = caller( $i++ ) ) {
                if ( $package =~ /^DBIx?::/ ) {
                    last;
                }
            }
            $_[0] =~ s! !/* at $file line $line */ !;

            $next->(@_);
        }
    );
}

1;

