use strict;
use warnings;
use utf8;

package DBIx::Pluggable::TransactionManager;

sub init {
    my ($class, $pkg, $opts) = @_;

    no strict 'refs';
    *{"$pkg\::txn_manager"} = \&txn_manager;
    *{"$pkg\::txn_scope"}   = \&txn_scope;
    *{"$pkg\::txn_begin"}   = \&txn_begin;
    *{"$pkg\::txn_end"}     = \&txn_end;
}

sub txn_manager {
    my $self = shift;
    $self->{private_txn_manager} //= DBIx::TransactionManager->new($self);
}

sub txn_scope { $_[0]->txn_manager->txn_scope(caller => [caller(0)]) }
sub txn_begin { $_[0]->txn_manager->txn_begin() }
sub txn_end   { $_[0]->txn_manager->txn_end() }

1;

