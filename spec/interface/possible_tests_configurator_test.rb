require 'attest/interface/possible_tests_configurator'

this_tests "possible tests configurator" do 
  test("raises exception if no included test locations") do 
    should_raise {PossibleTestsConfigurator.configure(nil)}
  end

  test("should return one location simulating passing in one file") do 
    included_location = ["file1.rb"]
    expected_included_location = ["expanded/file1.rb"]
    File.stubs(:expand_path).returns(expected_included_location[0])
    PossibleTestsConfigurator.stubs(:file_list_from_single).returns(expected_included_location[0])
    actual_included_location = PossibleTestsConfigurator.configure(included_location)
    should_equal(expected_included_location, actual_included_location)
  end

  test("should return two locations simulating passing in one directory with two files") do 
    included_location = ["dir1"]
    expanded_dir_location = "expanded/dir1"
    expected_included_locations = ["expanded/file1.rb", "expanded/file2.rb"]
    File.expects(:expand_path).with(included_location[0]).returns(expanded_dir_location)
    PossibleTestsConfigurator.stubs(:file_list_from_single).returns(expected_included_locations)
    actual_included_locations = PossibleTestsConfigurator.configure(included_location)
    should_equal(expected_included_locations, actual_included_locations)
  end

  test("should return three locations passing in one file and one directory with two files") do 
  end

  test("should return two locations passing in one file and one dir with 2 files one of which is excluded") do 
  end
end
