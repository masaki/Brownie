use Test::More;
eval {
    require Test::Perl::Critic;
    Test::Perl::Critic->import(-profile => 'xt/perlcriticrc');
};
plan skip_all => "Test::Perl::Critic is not installed." if $@;
plan skip_all => "set TEST_CRITIC or TEST_ALL to enable this test"
    unless $ENV{TEST_CRITIC} or $ENV{TEST_ALL};
all_critic_ok('lib');
