use Test::More;
eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;
plan skip_all => "set TEST_POD or TEST_ALL to enable this test"
    unless $ENV{TEST_POD} or $ENV{TEST_ALL};
all_pod_coverage_ok();
