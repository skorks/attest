require 'attest/interface/possible_tests_configurator'
require 'fakefs/safe'

this_tests "possible tests configurator" do 

  before_all do 
    FakeFS.activate!
    FakeFS::FileSystem.clear
    @base_test_path = "/path/to/tests"
    @sub_test_dir_name = "sub_test_dir"
    @sub_test_dir_path = "#{@base_test_path}/#{@sub_test_dir_name}"
    @test_file_names = ["file1.rb","file2.rb","file3.rb"]
    @test_file1_path = "#{@base_test_path}/#{@test_file_names[0]}"
    @test_file2_path = "#{@sub_test_dir_path}/#{@test_file_names[1]}"
    @test_file3_path = "#{@sub_test_dir_path}/#{@test_file_names[2]}"
    FileUtils.mkdir_p(@base_test_path)
    FileUtils.mkdir_p(@sub_test_dir_path)
    File.open(@test_file1_path, 'w') {|f| f.write("require 'pp'")}
    File.open(@test_file2_path, 'w') {|f| f.write("require 'pp'")}
    File.open(@test_file3_path, 'w') {|f| f.write("require 'pp'")}
  end

  after_all do 
    FakeFS.deactivate!
  end

  test("raises exception if no included test locations") do 
    should_raise {PossibleTestsConfigurator.configure(nil)}
  end

  test("should return one location when single file is passed in") do 
    included_locations = [@test_file1_path]
    actual_included_location = PossibleTestsConfigurator.configure(included_locations)
    should_equal([@test_file1_path], actual_included_location)
  end

  test("should return two locations when directory with two files is passed in") do 
    included_locations = [@sub_test_dir_path]
    actual_included_locations = PossibleTestsConfigurator.configure(included_locations)
    should_equal([@test_file2_path, @test_file3_path], actual_included_locations)
  end

  test("should return three locations when single file and dir with two files is passed in") do 
    included_locations = [@sub_test_dir_path, @test_file1_path]
    actual_included_locations = PossibleTestsConfigurator.configure(included_locations)
    should_equal([@test_file2_path, @test_file3_path, @test_file1_path], actual_included_locations)
  end

  test("should return two locations passing in one file and one dir with 2 files one of which is excluded") do 
    included_locations = [@sub_test_dir_path, @test_file1_path]
    excluded_locations = [@test_file2_path]
    actual_included_locations = PossibleTestsConfigurator.configure(included_locations, excluded_locations)
    should_equal([@test_file3_path, @test_file1_path], actual_included_locations)
  end
end
