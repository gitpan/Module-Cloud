use inc::Module::Install;
name 'Module-Cloud';
all_from 'lib/Module/Cloud.pm';

requires 'Class::MethodMaker';
requires 'File::Find::Rule::MMagic';
requires 'Getopt::Attribute';
requires 'HTML::TagCloud';
requires 'Module::ExtractUse';

build_requires 'Test::More';
install_script 'bin/module_cloud';

use_test_base;
auto_include;
WriteAll;
