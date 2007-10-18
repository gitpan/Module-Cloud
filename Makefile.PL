use inc::Module::Install;
name 'Module-Cloud';
all_from 'lib/Module/Cloud.pm';
perl_version '5.006';

requires 'Class::Accessor::Complex';
requires 'File::Find::Rule::MMagic';
requires 'Getopt::Attribute';
requires 'HTML::TagCloud';
requires 'Module::ExtractUse';

build_requires 'Test::More' => '0.70';

install_script 'bin/module_cloud';

use_standard_tests;
auto_include;
WriteAll;
