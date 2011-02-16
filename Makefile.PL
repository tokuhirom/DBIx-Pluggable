use inc::Module::Install;
use Module::Install::AuthorTests;

name 'DBIx-Pluggable';
all_from 'lib/DBIx/Pluggable.pm';

requires 'DBI';
requries 'Class::Method::Modifiers';
recommends 'DBIx::TransactionManager';
recommends 'SQL::Interp';
recommends 'SQL::Maker';

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More' => 0.96; # done_testing, subtest
# test_requires 'Test::Requires';
author_tests('xt');
WriteAll;
