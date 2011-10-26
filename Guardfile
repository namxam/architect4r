guard 'rspec', :all_after_pass => false, :version => 2 do
  # Check for changes in classes
  watch(%r{^lib/architect4r/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  
  # Check for changes in specs
  watch(%r{^spec/.+_spec\.rb$})
  
  # Check for changes in the spec helper
  watch('spec/spec_helper.rb')  { "spec" }
end