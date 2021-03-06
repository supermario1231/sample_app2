require "spec_helper"

describe Autotest::Rspec2 do
  let(:rspec_autotest) { Autotest::Rspec2.new }
  let(:spec_cmd) { File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'bin', 'rspec')) }
  let(:ruby_cmd) { "ruby" }

  before do
    File.stub(:exist?) { false }
  end

  it "uses autotest's prefix" do
    rspec_autotest.prefix = "this is the prefix "
    rspec_autotest.
      make_test_cmd({'a' => 'b'}).should match(/this is the prefix/)
  end

  describe "commands" do
    before do
      rspec_autotest.stub(:ruby => ruby_cmd)
      files = %w[file_one file_two]
      @files_to_test = {
        files[0] => [],
        files[1] => []
      }
      # this is not the inner representation of Autotest!
      rspec_autotest.files_to_test = @files_to_test
      @to_test = files.map { |f| File.expand_path(f) }.join ' '
    end

    it "makes the appropriate test command" do
      actual_command = rspec_autotest.make_test_cmd(@files_to_test)
      expected_command = /#{ruby_cmd}.*#{spec_cmd} (.*)/

      actual_command.should match(expected_command)

      actual_command =~ expected_command
      $1.should =~ /#{File.expand_path('file_one')}/
      $1.should =~ /#{File.expand_path('file_two')}/
    end

    it "returns a blank command for no files" do
      rspec_autotest.make_test_cmd({}).should eq('')
    end

    it "quotes the paths of files to test" do
      cmd = rspec_autotest.make_test_cmd(@files_to_test)
      @files_to_test.keys.each do |file_to_test|
        cmd.should match(/'#{File.expand_path(file_to_test)}'/)
      end
    end

    it "gives '--tty' to #{Autotest::Rspec2::SPEC_PROGRAM}, not '--autotest'" do
      cmd = rspec_autotest.make_test_cmd(@files_to_test)
      cmd.should match(' --tty ')
      cmd.should_not match(' --autotest ')
    end
  end

  describe "mappings" do
    before do
      @lib_file = "lib/something.rb"
      @spec_file = "spec/something_spec.rb"
      rspec_autotest.hook :initialize
    end

    it "finds the spec file for a given lib file" do
      rspec_autotest.should map_specs([@spec_file]).to(@lib_file)
    end

    it "finds the spec file if given a spec file" do
      rspec_autotest.should map_specs([@spec_file]).to(@spec_file)
    end

    it "ignores files in spec dir that aren't specs" do
      rspec_autotest.should map_specs([]).to("spec/spec_helper.rb")
    end

    it "ignores untracked files (in @file)"  do
      rspec_autotest.should map_specs([]).to("lib/untracked_file")
    end
  end

  describe "consolidating failures" do
    let(:subject_file) { "lib/autotest/some.rb" }
    let(:spec_file)    { "spec/autotest/some_spec.rb" }

    it "returns no failures if no failures were given in the output" do
      rspec_autotest.consolidate_failures([[]]).should == {}
    end

    it "returns a hash with the spec filename => spec name for each failure or error" do
      failures = [ [ "false should be false", spec_file ] ]
      rspec_autotest.consolidate_failures(failures).should == {
        spec_file => ["false should be false"]
      }
    end

    context "when subject file appears before the spec file in the backtrace" do
      let(:failures) do
        [ [ "false should be false", "#{subject_file}:143:\n#{spec_file}:203:" ] ]
      end

      it "excludes the subject file" do
        rspec_autotest.consolidate_failures(failures).keys.should_not include(subject_file)
      end

      it "includes the spec file" do
        rspec_autotest.consolidate_failures(failures).keys.should include(spec_file)
      end
    end
  end

  describe "normalizing file names" do
    it "ensures that a single file appears in files_to_test only once" do
      @files_to_test = {}
      ['filename.rb', './filename.rb', File.expand_path('filename.rb')].each do |file|
        @files_to_test[file] = []
      end
      rspec_autotest.normalize(@files_to_test).should have(1).file
    end
  end
end
