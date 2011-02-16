package DBIx::Pluggable;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.01';
use DBI;
use Module::Load ();
use Data::OptList ();

sub setup {
    my $class = shift;

    # setup plugins
    no strict 'refs';
    unshift @{"${class}::ISA"},     'DBI';
    unshift @{"${class}::st::ISA"}, 'DBI::st';
    unshift @{"${class}::db::ISA"}, 'DBI::db';
    unshift @{"${class}::dr::ISA"}, 'drI::dr';
    return;
}

sub load_plugin {
    my ($class, $plugin, $opt) = @_;
    $plugin = $plugin =~ s/^\+// ? $plugin : "DBIx::Pluggable::$plugin";
    Module::Load::load($plugin);
    $plugin->init($class, $opt || +{});
    return;
}

sub load_plugins {
    my $class = shift;
    my $opts = Data::OptList::mkopt(\@_);
    for (@$opts) {
        $class->load_plugin(@$_);
    }
    return;
}

1;
__END__

=encoding utf8

=head1 NAME

DBIx::Pluggable -

=head1 SYNOPSIS

    package MyApp::DBI;
    use parent qw/DBIx::Pluggable/;
    __PACKAGE__->setup();
    __PACKAGE__->load_plugins(
        qw/
            TransactionManager
        /
    );

=head1 DESCRIPTION

DBIx::Pluggable is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF GMAIL COME<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
